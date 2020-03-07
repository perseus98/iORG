package com.sudeshi.iorgkt.db.dao

import androidx.lifecycle.LiveData
import androidx.room.Dao
import androidx.room.Insert
import androidx.room.OnConflictStrategy
import androidx.room.Query
import com.sudeshi.iorgkt.db.model.Data

@Dao
interface DataDAO {
    @Query("SELECT * FROM table_data")
    fun getAllMainData(): LiveData<List<Data>>

    @Insert(onConflict = OnConflictStrategy.IGNORE)
    suspend fun insertMainData(data: Data)

    @Query("DELETE FROM table_data")
    suspend fun deleteAllMap()
}