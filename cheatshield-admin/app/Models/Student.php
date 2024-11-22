<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\SoftDeletes;

class Student extends Model
{
    use HasFactory, SoftDeletes;

    /**
     * @var array
     */
    protected $fillable = [
        'user_id',
        'nim',
        'gender',
        'photo',
    ];

    /**
     * @var array
     */
    protected $casts = [
        'user_id' => 'uuid',
    ];

    /**
     * @return BelongsTo<User,Student>
     */
    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }
}
