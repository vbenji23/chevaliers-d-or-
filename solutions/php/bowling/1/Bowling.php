<?php

declare(strict_types=1);

class Game
{
    /** @var int[] */
    private array $rolls = [];

    public function roll(int $pins): void
    {
        if ($pins < 0 || $pins > 10) {
            throw new Exception("Pins must be between 0 and 10.");
        }

        if ($this->isFinished()) {
            throw new Exception("Cannot roll after the game is complete.");
        }

        // Valider qu'un lancer dans un frame normal ne dépasse pas 10 quilles au total
        $this->validateFrameRoll($pins);

        $this->rolls[] = $pins;
    }

    public function score(): int
    {
        if (!$this->isFinished()) {
            throw new Exception("Cannot score an incomplete game.");
        }

        $score = 0;
        $rollIndex = 0;

        for ($frame = 0; $frame < 10; $frame++) {
            if ($this->isStrike($rollIndex)) {
                $score += 10 + $this->rolls[$rollIndex + 1] + $this->rolls[$rollIndex + 2];
                $rollIndex++;
            } elseif ($this->isSpare($rollIndex)) {
                $score += 10 + $this->rolls[$rollIndex + 2];
                $rollIndex += 2;
            } else {
                $score += $this->rolls[$rollIndex] + $this->rolls[$rollIndex + 1];
                $rollIndex += 2;
            }
        }

        return $score;
    }

    private function isStrike(int $rollIndex): bool
    {
        return $this->rolls[$rollIndex] === 10;
    }

    private function isSpare(int $rollIndex): bool
    {
        return $this->rolls[$rollIndex] + $this->rolls[$rollIndex + 1] === 10;
    }

    private function isFinished(): bool
    {
        $rollIndex = 0;

        for ($frame = 0; $frame < 10; $frame++) {
            if ($rollIndex >= count($this->rolls)) {
                return false;
            }

            if ($frame === 9) { // 10ème frame
                if ($this->isStrike($rollIndex)) {
                    return count($this->rolls) >= $rollIndex + 3;
                }
                if ($rollIndex + 1 < count($this->rolls) && $this->isSpare($rollIndex)) {
                    return count($this->rolls) >= $rollIndex + 3;
                }
                return count($this->rolls) >= $rollIndex + 2;
            }

            if ($this->isStrike($rollIndex)) {
                $rollIndex++;
            } else {
                if ($rollIndex + 1 >= count($this->rolls)) {
                    return false;
                }
                $rollIndex += 2;
            }
        }

        return true;
    }

    private function validateFrameRoll(int $pins): void
    {
        $rollIndex = 0;

        for ($frame = 0; $frame < 10; $frame++) {
            if ($rollIndex >= count($this->rolls)) {
                // Premier lancer du frame en cours
                return;
            }

            if ($frame === 9) { // 10ème frame (règles spéciales)
                $count = count($this->rolls) - $rollIndex;

                if ($count === 1) {
                    $first = $this->rolls[$rollIndex];
                    if ($first < 10 && ($first + $pins > 10)) {
                        throw new Exception("Two rolls in 10th frame cannot exceed 10 pins.");
                    }
                } elseif ($count === 2) {
                    $first = $this->rolls[$rollIndex];
                    $second = $this->rolls[$rollIndex + 1];

                    if ($first === 10 && $second < 10 && ($second + $pins > 10)) {
                        throw new Exception("Two bonus rolls after strike cannot exceed 10 pins unless first is a strike.");
                    }
                }
                return;
            }

            if ($this->isStrike($rollIndex)) {
                $rollIndex++;
            } else {
                if ($rollIndex + 1 >= count($this->rolls)) {
                    // Deuxième lancer du frame normal
                    if ($this->rolls[$rollIndex] + $pins > 10) {
                        throw new Exception("Two rolls in a frame cannot exceed 10 pins.");
                    }
                    return;
                }
                $rollIndex += 2;
            }
        }
    }
}
