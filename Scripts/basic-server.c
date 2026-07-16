#ifndef WIN32_LEAN_AND_MEAN
#define WIN32_LEAN_AND_MEAN
#endif

#include <windows.h>
#include <winsock2.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#pragma comment(lib, "ws2_32.lib")

#define PORT 1337
#define FILENAME "index.html"
#define BUFFER_SIZE 8192

// Helper to get the last modified time of a file as a 64-bit integer
unsigned long long get_file_time(const char* filename) {
    WIN32_FILE_ATTRIBUTE_DATA fileInfo;
    if (GetFileAttributesExA(filename, GetFileExInfoStandard, &fileInfo)) {
        return ((unsigned long long)fileInfo.ftLastWriteTime.dwHighDateTime << 32) 
               | fileInfo.ftLastWriteTime.dwLowDateTime;
    }
    return 0;
}

// Function to read HTML and inject the auto-reload script dynamically
void serve_html_with_script(SOCKET client_sock) {
    FILE* f = fopen(FILENAME, "r");
    if (!f) {
        const char* not_found = "HTTP/1.1 404 Not Found\r\nContent-Length: 9\r\n\r\nNot Found";
        send(client_sock, not_found, (int)strlen(not_found), 0);
        return;
    }

    // Read the file content
    char file_buf[BUFFER_SIZE] = {0};
    size_t bytes_read = fread(file_buf, 1, BUFFER_SIZE - 1, f);
    fclose(f);

    // Javascript payload that hangs on /watch until the server responds
    const char* inject_script = 
        "<script>\n"
        "  function watchFile() {\n"
        "    fetch('/watch')\n"
        "      .then(res => { if(res.ok) location.reload(); })\n"
        "      .catch(() => setTimeout(watchFile, 1000));\n"
        "  }\n"
        "  watchFile();\n"
        "</script>\n";

    // Send HTTP Headers
    const char* headers = "HTTP/1.1 200 OK\r\nContent-Type: text/html\r\nConnection: close\r\n\r\n";
    send(client_sock, headers, (int)strlen(headers), 0);

    // Find </body> tag to inject the script cleanly
    char* body_tag = strstr(file_buf, "</body>");
    if (body_tag) {
        // Send up to the </body> tag
        int first_part_len = (int)(body_tag - file_buf);
        send(client_sock, file_buf, first_part_len, 0);
        // Send the script
        send(client_sock, inject_script, (int)strlen(inject_script), 0);
        // Send the rest of the file
        send(client_sock, body_tag, (int)strlen(body_tag), 0);
    } else {
        // Fallback if </body> isn't found: just append it at the end
        send(client_sock, file_buf, (int)bytes_read, 0);
        send(client_sock, inject_script, (int)strlen(inject_script), 0);
    }
}

int main() {
    WSADATA wsaData;
    SOCKET server_fd = INVALID_SOCKET;
    SOCKET watch_client = INVALID_SOCKET;
    struct sockaddr_in address;
    int addrlen = sizeof(address);
    char recv_buf[1024] = {0};

    // Initialize Winsock
    if (WSAStartup(MAKEWORD(2, 2), &wsaData) != 0) {
        printf("Winsock initialization failed.\n");
        return 1;
    }

    // Create Socket
    if ((server_fd = socket(AF_INET, SOCK_STREAM, 0)) == INVALID_SOCKET) {
        printf("Socket creation failed.\n");
        WSACleanup();
        return 1;
    }

    // Configure server address
    address.sin_family = AF_INET;
    address.sin_addr.s_addr = INADDR_ANY;
    address.sin_port = htons(PORT);

    // Bind
    if (bind(server_fd, (struct sockaddr*)&address, sizeof(address)) == SOCKET_ERROR) {
        printf("Bind failed.\n");
        closesocket(server_fd);
        WSACleanup();
        return 1;
    }

    // Listen
    if (listen(server_fd, 3) == SOCKET_ERROR) {
        printf("Listen failed.\n");
        closesocket(server_fd);
        WSACleanup();
        return 1;
    }

    // Set Server Socket to Non-Blocking Mode
    u_long mode = 1;
    ioctlsocket(server_fd, FIONBIO, &mode);

    // Track the file modification time
    unsigned long long last_known_time = get_file_time(FILENAME);
    printf("Dev server running at http://localhost:%d\n", PORT);
    printf("Watching for changes in '%s'...\n", FILENAME);

    // Main Single-Threaded Execution Loop
    while (1) {
        // 1. Try to accept a new client connection (Non-blocking)
        SOCKET client_fd = accept(server_fd, (struct sockaddr*)&address, &addrlen);
        
        if (client_fd != INVALID_SOCKET) {
            // Read client request header
            memset(recv_buf, 0, sizeof(recv_buf));
            int bytes_received = recv(client_fd, recv_buf, sizeof(recv_buf) - 1, 0);
            
            if (bytes_received > 0) {
                if (strstr(recv_buf, "GET /watch")) {
                    // Browser requested the watcher channel.
                    // Do not close it, do not answer yet. Save it for later.
                    if (watch_client != INVALID_SOCKET) {
                        closesocket(watch_client); // Close any stale watch connection
                    }
                    watch_client = client_fd;
                } 
                else if (strstr(recv_buf, "GET /")) {
                    // Browser requested the page layout. Serve HTML + Javascript code.
                    serve_html_with_script(client_fd);
                    closesocket(client_fd);
                } 
                else {
                    // Handle everything else with a simple 404 response
                    const char* not_found = "HTTP/1.1 404 Not Found\r\nContent-Length: 0\r\n\r\n";
                    send(client_fd, not_found, (int)strlen(not_found), 0);
                    closesocket(client_fd);
                }
            } else {
                closesocket(client_fd);
            }
        }

        // 2. Check if the tracked file updated on disk
        unsigned long long current_time = get_file_time(FILENAME);
        if (current_time > last_known_time) {
            printf("[File Change Detected] Sending reload signal to browser...\n");
            last_known_time = current_time;

            // If a browser is waiting on the /watch route, release it now!
            if (watch_client != INVALID_SOCKET) {
                const char* reply = "HTTP/1.1 200 OK\r\nContent-Length: 0\r\nConnection: close\r\n\r\n";
                send(watch_client, reply, (int)strlen(reply), 0);
                closesocket(watch_client);
                watch_client = INVALID_SOCKET; // Reset holder state
            }
        }

        // 3. Keep CPU at 0% usage by resting 50 milliseconds every pass
        Sleep(50);
    }

    // Cleanup resources
    closesocket(server_fd);
    WSACleanup();
    return 0;
}

