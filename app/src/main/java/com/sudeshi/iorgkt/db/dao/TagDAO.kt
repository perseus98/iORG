package com.sudeshi.iorgkt.db.dao

import androidx.lifecycle.LiveData
import androidx.room.Dao
import androidx.room.Insert
import androidx.room.OnConflictStrategy
import androidx.room.Query
import com.sudeshi.iorgkt.db.model.Tag

@Dao
interface TagDAO {
    @Query("SELECT * FROM table_tag")
    fun getAllTags(): LiveData<List<Tag>>

    @Insert(onConflict = OnConflictStrategy.IGNORE)
    suspend fun insertTag(tag: Tag)

    @Query("DELETE FROM table_tag")
    suspend fun deleteAllTag()
}