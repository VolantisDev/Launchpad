class UnixTimestampConverter extends ConverterBase {
    Convert(unixTimestamp) {
        return DateAdd(19700101000000, unixTimestamp, "S")
    }
}
