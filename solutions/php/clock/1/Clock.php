<?php

declare(strict_types=1);

class Clock
{
    private const MINUTES_PER_DAY = 1440;
    private const MINUTES_PER_HOUR = 60;

    private int $minutes;

    public function __construct(int $hours = 0, int $minutes = 0)
    {
        $totalMinutes = ($hours * self::MINUTES_PER_HOUR) + $minutes;
        $this->minutes = $this->normalizeMinutes($totalMinutes);
    }

    public function add(int $minutes): self
    {
        return new self(0, $this->minutes + $minutes);
    }

    public function sub(int $minutes): self
    {
        return new self(0, $this->minutes - $minutes);
    }

    public function __toString(): string
    {
        $hours = intdiv($this->minutes, self::MINUTES_PER_HOUR);
        $minutes = $this->minutes % self::MINUTES_PER_HOUR;

        return sprintf('%02d:%02d', $hours, $minutes);
    }

    private function normalizeMinutes(int $minutes): int
    {
        $normalized = $minutes % self::MINUTES_PER_DAY;
        if ($normalized < 0) {
            $normalized += self::MINUTES_PER_DAY;
        }

        return $normalized;
    }
}