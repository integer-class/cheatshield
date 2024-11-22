<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\SoftDeletes;

class StudentEmbedding extends Model
{
    use HasFactory, SoftDeletes;

    /**
     * @var array
     */
    protected $fillable = [
        'student_id',
        'embedding',
    ];

    /**
     * @var array
     */
    protected $casts = [
        'embedding' => 'binary',
    ];

    /**
     * @return BelongsTo<Student,StudentEmbedding>
     */
    public function student(): BelongsTo
    {
        return $this->belongsTo(Student::class);
    }
}
