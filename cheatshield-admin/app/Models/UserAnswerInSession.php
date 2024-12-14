<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\SoftDeletes;

class UserAnswerInSession extends Model
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
        'question_id',
        'answer_id',
    ];

    /**
     * @var array
     */
    protected $casts = [
        'user_id' => 'string',
        'quiz_session_id' => 'string',
        'question_id' => 'string',
        'answer_id' => 'string',
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
