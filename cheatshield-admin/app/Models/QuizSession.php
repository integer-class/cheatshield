<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\SoftDeletes;

class QuizSession extends Model
{
    use HasFactory, SoftDeletes;

    /**
     * @var array
     */
    protected $fillable = [
        'quiz_id',
        'code',
        'title',
        'description',
        'is_active',
        'duration',
        'started_at',
        'completed_at',
    ];

    /**
     * @var array
     */
    protected $casts = [
        'is_active' => 'boolean',
        'duration' => 'integer',
        'started_at' => 'datetime',
        'completed_at' => 'datetime',
    ];

    /**
     * @return BelongsTo<Quiz,QuizSession>
     */
    public function quiz(): BelongsTo
    {
        return $this->belongsTo(Quiz::class);
    }

    /**
     * @return HasMany<QuizSessionResult,QuizSession>
     */
    public function results(): HasMany
    {
        return $this->hasMany(QuizSessionResult::class);
    }
}
