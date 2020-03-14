package com.sudeshi.iorgkt.db.model

import androidx.room.*
import com.sudeshi.iorgkt.support.DateTypeConverter
import java.time.OffsetDateTime

@Entity(tableName = "table_data", indices = [Index(value = ["id"])])
@TypeConverters(DateTypeConverter::class)
data class Data(
    //Data = id, name, pic_path, date, priority
    @PrimaryKey(autoGenerate = true)
    @ColumnInfo(name = "id")
    val id: Int,
    @ColumnInfo(name = "name")
    val name: String,
    @ColumnInfo(name = "pic_path")
    val pic_path: String,
    @ColumnInfo(name = "date")
    val date: OffsetDateTime,
    @ColumnInfo(name = "priority")
    val priority: Int
)