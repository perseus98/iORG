package com.sudeshi.iorgkt.db.model

import androidx.room.*
import com.sudeshi.iorgkt.support.DateTypeConverter
import java.time.OffsetDateTime

@Entity(tableName = "table_data", indices = [Index(value = ["id"])])
@TypeConverters(DateTypeConverter::class)
class Data(
    arg_id: Long,
    arg_name: String,
    arg_path: String,
    arg_date: OffsetDateTime,
    arg_priority: Int
) {
    //Data = id, name, pic_path, date, priority
    @PrimaryKey(autoGenerate = true)
    @ColumnInfo(name = "id")
    var id: Long = arg_id
    @ColumnInfo(name = "name")
    var name: String = arg_name
    @ColumnInfo(name = "pic_path")
    var pic_path: String = arg_path
    @ColumnInfo(name = "date")
    var date: OffsetDateTime = arg_date
    @ColumnInfo(name = "priority")
    var priority: Int = arg_priority

    fun getDataId(): Long {
        return id
    }

}
