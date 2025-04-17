#include "ej1.h"
#include <stdio.h>

string_proc_list* string_proc_list_create(void) {
    string_proc_list* list = (string_proc_list*)malloc(sizeof(string_proc_list));
    if (list == NULL) {
        return NULL;
    }
    list->first = NULL;
    list->last = NULL;
    return list;
}

string_proc_node* string_proc_node_create(uint8_t type, char* hash) {
    string_proc_node* node = (string_proc_node*)malloc(sizeof(string_proc_node));
    if (node == NULL || hash == NULL) {
        return NULL;
    }
    node->type = type;
    node->hash = hash;
    node->next = NULL;
    node->previous = NULL;
    return node;
}

void string_proc_list_add_node(string_proc_list* list, uint8_t type, char* hash) {
    if (list == NULL || hash == NULL) {
        return;
    }

    string_proc_node* new_node = string_proc_node_create(type, hash);

    if (list->first == NULL) {
        list->first = new_node;
        list->last = new_node;
    } else {
        list->last->next = new_node;
        new_node->previous = list->last;
        list->last = new_node;
    }
}

char* string_proc_list_concat(string_proc_list* list, uint8_t type, char* hash) {
    if (list == NULL || hash == NULL) {
        return NULL;
    }

    char* result = str_concat("", hash);
    if (result == NULL) {
        return NULL; 
    }

    string_proc_node* current = list->first;
    while (current != NULL) {
        if (current->type == type) {
            char* old_result = result;
            result = str_concat(result, current->hash);
            if (result == NULL) {
                free(old_result);  // Liberamos la memoria si la asignación falla
                return NULL;
            }
            free(old_result);  // Liberamos la memoria anterior
        }
        current = current->next;
    }
    return result;
}

/** AUX FUNCTIONS **/

void string_proc_list_destroy(string_proc_list* list) {
    if (list == NULL) return;

    // Borro los nodos
    string_proc_node* current_node = list->first;
    string_proc_node* next_node = NULL;
    
    while (current_node != NULL) {
        next_node = current_node->next;
        string_proc_node_destroy(current_node); // Liberar el nodo
        current_node = next_node;
    }

    // Borro la lista
    free(list);
}

void string_proc_node_destroy(string_proc_node* node) {
    // No liberar la memoria de 'node->hash' si no fue asignada dentro del nodo
    node->next = NULL;
    node->previous = NULL;
    node->hash = NULL;  // No es necesario liberar aquí si 'hash' no fue asignado dinámicamente
    free(node);
}

/**
 * Concatena dos strings a y b. 
 * Retorna el resultado en uno nuevo, creado via malloc.
 */
char* str_concat(char* a, char* b) {
    int len1 = strlen(a);
    int len2 = strlen(b);
    int totalLength = len1 + len2;
    
    char* result = (char*)malloc(totalLength + 1);  // +1 para el null terminator
    if (result == NULL) {
        return NULL; // Verifica si malloc falla
    }

    strcpy(result, a);
    strcat(result, b);
    return result;  
}

/**
 * Imprime la lista list en el archivo file.
 */
void string_proc_list_print(string_proc_list* list, FILE* file) {
    if (list == NULL || file == NULL) return;

    uint32_t length = 0;
    string_proc_node* current_node = list->first;
    while (current_node != NULL) {
        length++;
        current_node = current_node->next;
    }
    fprintf(file, "List length: %d\n", length);

    current_node = list->first;
    while (current_node != NULL) {
        fprintf(file, "\tnode hash: %s | type: %d\n", current_node->hash, current_node->type);
        current_node = current_node->next;
    }
}
