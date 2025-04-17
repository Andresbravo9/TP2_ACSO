import sys

def binary_search_iterations(word_list, target_word):
    """
    Simula la búsqueda binaria recursiva de 'cuenta' y cuenta las iteraciones.

    Args:
        word_list: Una lista ordenada de palabras.
        target_word: La palabra a buscar.

    Returns:
        Número de iteraciones si se encuentra dentro del límite de 11.
        -2 si se exceden las 11 iteraciones.
        -1 si la palabra no se encuentra.
    """
    low = 0
    high = len(word_list) - 1
    iterations = 0  

    while low <= high:
        iterations += 1

        if iterations > 11:
            return -2  # Indica que se excedió el límite

        mid = low + (high - low) // 2
        mid_word = word_list[mid]

        if mid_word == target_word:
            return iterations  
        elif mid_word < target_word:
            low = mid + 1  
        else: 
            high = mid - 1 

    return -1 # No encontrado 


def analyze_palabras(file_path):
    """
    Lee y analiza el archivo.
    """

    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            # Eliminar espacios en blanco al inicio/final y filtrar líneas vacías
            original_words = [line.strip() for line in f if line.strip()]
    except Exception as e:
        print(f"Error al leer el archivo '{file_path}': {e}")
        sys.exit(1)

    n_words = len(original_words)
    print(f"Archivo '{file_path}' leído y ordenado. Total de palabras: {n_words}")
    print("Buscando una palabra que requiera entre 7 y 11 iteraciones...")

    found_solution = None

    for word in original_words:
        iters = binary_search_iterations(original_words, word)

        if 7 <= iters <= 11:
            found_solution = (word, iters)
            print("¡Solución encontrada para la Fase 3!")
            print(f"  Palabra: '{found_solution[0]}'")
            print(f"  Iteraciones: {found_solution[1]}")
            print(f"\n  CLAVE PARA FASE 3: {found_solution[0]} {found_solution[1]}")
            break 
      
    if not found_solution:
        print("Análisis completo. No se encontró ninguna palabra en el rango de 7-11 iteraciones.")
        print("Verifica que:")
        print("  1. Estás usando el archivo 'palabras.txt' correcto para tu bomba.")
        print("  2. El archivo está (o fue) ordenado alfabéticamente.")
        print("  3. Los límites de iteraciones en tu bomba (phase_3 y cuenta) son realmente >6 y <=11.")

if __name__ == "__main__":
    default_path = "palabras.txt"
    analyze_palabras(default_path)