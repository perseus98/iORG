package com.sudeshi.iorgkt.db.dao

import androidx.lifecycle.LiveData
import androidx.room.Dao
import androidx.room.Insert
import androidx.room.OnConflictStrategy
import androidx.room.Query
import com.sudeshi.iorgkt.db.model.Map

@Dao
interface MapDAO {
    @Query("SELECT * FROM table_map")
    fun getAllMapData(): LiveData<List<Map>>

    @Insert(onConflict = OnConflictStrategy.IGNORE)
    suspend fun insertMapData(map: Map)

    @Query("DELETE FROM table_map")
    suspend fun deleteAllMap()
}