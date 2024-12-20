<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\SoftDeletes;

class QuizSession extends Model
{
    use HasFactory, HasUuids, SoftDeletes;

    protected $primaryKey = 'id';
    protected $keyType = 'string';
    public $incrementing = false;

    /**
     * @var array
     */
    protected $fillable = [
        'quiz_id',
        'code',
        'title',
        'started_at',
        'completed_at',
    ];

    /**
     * @var array
     */
    protected $casts = [
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
