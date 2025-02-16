#!/bin/bash

POKEMON="$1"
API_URL="https://pokeapi.co/api/v2/pokemon/$POKEMON"
CSV_FILE="pokemon_data.csv"

# Verificar si se proporcionó un parámetro
if [ -z "$POKEMON" ]; then
    echo "Uso: $0 <nombre_del_pokemon>"
    exit 1
fi

# Obtener los datos de la API
RESPONSE=$(curl -s "$API_URL")

# Verificar si el Pokemon existe
if echo "$RESPONSE" | jq -e .id >/dev/null 2>&1; then
    ID=$(echo "$RESPONSE" | jq .id)
    NAME=$(echo "$RESPONSE" | jq -r .name)
    WEIGHT=$(echo "$RESPONSE" | jq .weight)
    HEIGHT=$(echo "$RESPONSE" | jq .height)
    ORDER=$(echo "$RESPONSE" | jq .order)

    # Imprimir los resultados
    echo "${NAME^} (No. $ID)"
    echo "Id = $ID"
    echo "Weight = $WEIGHT"
    echo "Height = $HEIGHT"
    echo "Order = $ORDER"

    # Escribir en el archivo CSV
    if [ ! -f "$CSV_FILE" ]; then
        echo "id,name,weight,height,order" > "$CSV_FILE"
    fi
    echo "$ID,$NAME,$WEIGHT,$HEIGHT,$ORDER" >> "$CSV_FILE"
else
    echo "Alerta: El Pokémon '$POKEMON' no fue encontrado."
    exit 1
fi
