<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\SoftDeletes;

class QuizSessionResult extends Model
{
    use HasFactory, HasUuids, SoftDeletes;

    protected $primaryKey = 'id';
    protected $keyType = 'string';
    public $incrementing = false;

    /**
     * @var array
     */
    protected $fillable = [
        'user_id',
        'quiz_session_id',
        'total_score',
        'correct_answers',
        'incorrect_answers',
        'cheating_status',
    ];

    /**
     * @var array
     */
    protected $casts = [
        'total_score' => 'integer',
        'correct_answers' => 'integer',
        'incorrect_answers' => 'integer',
    ];

    /**
     * @return BelongsTo<User,QuizSessionResult>
     */
    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    /**
     * @return BelongsTo<QuizSession,QuizSessionResult>
     */
    public function quizSession(): BelongsTo
    {
        return $this->belongsTo(QuizSession::class);
    }
}
