<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\SoftDeletes;

class UserAnswerInSession extends Model
{
    use HasFactory, SoftDeletes;

    /**
     * @var array
     */
    protected $fillable = [
        'user_id',
        'quiz_session_id',
        'question_id',
        'answer_id',
    ];

    /**
     * @var array
     */
    protected $casts = [
        'user_id' => 'uuid',
        'quiz_session_id' => 'uuid',
        'question_id' => 'uuid',
        'answer_id' => 'uuid',
    ];

    /**
     * @return BelongsTo<User,UserAnswerInSession>
     */
    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    /**
     * @return BelongsTo<QuizSession,UserAnswerInSession>
     */
    public function quizSession(): BelongsTo
    {
        return $this->belongsTo(QuizSession::class);
    }

    /**
     * @return BelongsTo<Question,UserAnswerInSession>
     */
    public function question(): BelongsTo
    {
        return $this->belongsTo(Question::class);
    }

    /**
     * @return BelongsTo<Answer,UserAnswerInSession>
     */
    public function answer(): BelongsTo
    {
        return $this->belongsTo(Answer::class);
    }
}
