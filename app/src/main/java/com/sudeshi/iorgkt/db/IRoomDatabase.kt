package com.sudeshi.iorgkt.db

import android.content.Context
import androidx.room.Database
import androidx.room.Room
import androidx.room.RoomDatabase
import com.sudeshi.iorgkt.db.dao.DataDAO
import com.sudeshi.iorgkt.db.dao.MapDAO
import com.sudeshi.iorgkt.db.dao.TagDAO
import com.sudeshi.iorgkt.db.model.Data
import com.sudeshi.iorgkt.db.model.Map
import com.sudeshi.iorgkt.db.model.Tag

@Database(entities = [Tag::class, Map::class, Data::class], version = 1, exportSchema = true)
public abstract class IRoomDatabase : RoomDatabase() {
    abstract fun tagDao(): TagDAO
    abstract fun dataDao(): DataDAO
    abstract fun mapDao(): MapDAO

    companion object {
        @Volatile
        private var INSTANCE: IRoomDatabase? = null

        fun getDatabase(context: Context): IRoomDatabase {
            val tempInstance = INSTANCE
            if (tempInstance != null) {
                return tempInstance
            }
            synchronized(this) {
                val instance = Room.databaseBuilder(
                    context.applicationContext,
                    IRoomDatabase::class.java,
                    "i_room_database"
                ).build()
                INSTANCE = instance
                return instance
            }
        }
    }
}