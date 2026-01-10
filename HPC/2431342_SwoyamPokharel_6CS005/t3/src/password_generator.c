#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#include <crypt.h>

#define SALT "$6$AS$"

char* cudaCrypt(char* rawPassword) {
    static char newPassword[11];
    newPassword[0] = rawPassword[0] + 2;
    newPassword[1] = rawPassword[0] - 2;
    newPassword[2] = rawPassword[0] + 1;
    newPassword[3] = rawPassword[1] + 3;
    newPassword[4] = rawPassword[1] - 3;
    newPassword[5] = rawPassword[1] - 1;
    newPassword[6] = rawPassword[2] + 2;
    newPassword[7] = rawPassword[2] - 2;
    newPassword[8] = rawPassword[3] + 4;
    newPassword[9] = rawPassword[3] - 4;
    newPassword[10] = '\0';

    for (int i = 0; i < 10; i++) {
        if (i >= 0 && i < 6) {
            if (newPassword[i] > 122) {
                newPassword[i] = (newPassword[i] - 122) + 97;
            } else if (newPassword[i] < 97) {
                newPassword[i] = (97 - newPassword[i]) + 97;
            }
        } else { // checking number section
            if (newPassword[i] > 57) {
                newPassword[i] = (newPassword[i] - 57) + 48;
            } else if (newPassword[i] < 48) {
                newPassword[i] = (48 - newPassword[i]) + 48;
            }
        }
    }
    return newPassword;
}

void generateRandomPassword(char* password) {
    password[0] = 'a' + (rand() % 26);
    password[1] = 'a' + (rand() % 26);
    password[2] = '0' + (rand() % 10);
    password[3] = '0' + (rand() % 10);
    password[4] = '\0';
}

int main(int argc, char* argv[]) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <number_of_passwords>\n", argv[0]);
        fprintf(stderr, "Example: %s 100\n", argv[0]);
        return 1;
    }

    int num_passwords = atoi(argv[1]);
    if (num_passwords <= 0) {
        fprintf(stderr, "Error: Number of passwords must be positive (got %d)\n", num_passwords);
        return 1;
    }

    srand(time(NULL));

    FILE* fp = fopen("password_encrypted.txt", "w");
    if (!fp) {
        fprintf(stderr, "Error: Cannot create output file\n");
        return 1;
    }

    printf("Generating %d encrypted passwords...\n", num_passwords);

    for (int i = 0; i < num_passwords; i++) {
        char rawPassword[5];
        generateRandomPassword(rawPassword);

        char* transformed = cudaCrypt(rawPassword);
        char* encrypted = crypt(transformed, SALT);

        fprintf(fp, "%s\n", encrypted);
    }

    fclose(fp);
    printf("Generated %d passwords. Saved to password_encrypted.txt\n", num_passwords);

    return 0;
}
