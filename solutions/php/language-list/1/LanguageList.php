<?php

function language_list(string ...$languages): array
{
    return $languages;
}

function add_to_language_list(array $languages, string $new_language): array
{
    $languages[] = $new_language;
    return $languages;
}

function prune_language_list(array $languages): array
{
    array_shift($languages);
    return $languages;
}

function current_language(array $languages): string
{
    return $languages[0];
}

function language_list_length(array $languages): int
{
    return count($languages);
}
