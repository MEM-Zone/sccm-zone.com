Function DeobfuscateSQLKey(ByVal sqlKeyBinary As Byte(), ByVal sqlVersion As Integer) As String
    '/* Test variables. !! Must be comented for production'
    'Dim sqlKeyBinary As Byte() = {1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0}
    'Dim sqlVersion As Integer = 12
    Dim charsArray As Char() = {"B","C","D","F","G","H","J","K","M","P","Q","R","T","V","W","X","Y","2","3","4","6","7","8","9"}
    Dim sqlProductKey As String
    Dim sqlKeyBinaryIndex As Integer
    Dim i, j, k As Integer
    Try
        If (sqlVersion >= 11) Then
            sqlKeyBinaryIndex = 0
        Else
            sqlKeyBinaryIndex = 52
        End If
        For i = 24 To 0 Step -1
            k = 0
            For j = 14 To 0 Step -1
                k = k * 256 Xor sqlKeyBinary(j + sqlKeyBinaryIndex)
                sqlKeyBinary(j + sqlKeyBinaryIndex) =  Math.Truncate(k / 24)
                k = k Mod 24
            Next j
            sqlProductKey = charsArray(k) + sqlProductKey
            If (i Mod 5) = 0 And i <> 0 Then
                sqlProductKey = "-" + sqlProductKey
            End If
        Next i
    Catch
        sqlProductKey = "Cannot decode product key."
    End Try
        DeobfuscateSQLKey = sqlProductKey
End Function