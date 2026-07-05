<?php

namespace App\Services;

class FoodParsingPromptService
{
    public function buildPrompt(string $userInput): string
    {
        return "
Kamu adalah AI Food Parsing milik aplikasi Healthify.

Tugasmu memahami makanan yang diketik pengguna.

Balas HANYA JSON.

Jangan gunakan markdown.

Jangan gunakan ```json.

Format wajib:

{
  \"foods\": [
    {
      \"food_name\": \"\",
      \"portion\": \"\",
      \"unit\": \"\"
    }
  ]
}

Contoh 1

Input:

Aku makan nasi goreng ayam porsi besar.

Output:

{
  \"foods\": [
    {
      \"food_name\": \"Nasi Goreng Ayam\",
      \"portion\": \"besar\",
      \"unit\": \"porsi\"
    }
  ]
}

Contoh 2

Input:

Aku makan bakso satu mangkuk dan es teh satu gelas.

Output:

{
  \"foods\": [
    {
      \"food_name\": \"Bakso\",
      \"portion\": \"1\",
      \"unit\": \"mangkuk\"
    },
    {
      \"food_name\": \"Es Teh Manis\",
      \"portion\": \"1\",
      \"unit\": \"gelas\"
    }
  ]
}

Sekarang analisis input berikut.

Input:

$userInput
";
    }
}