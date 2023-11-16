m1 = [1, 2, 3, 4, 5, 6, 7, 8, 9]
m2 = [1, 2, 3, 4, 5, 6, 7, 8, 9]

systolic_width = 2

m1_width = 3
m1_height = 3

m2_width = 3
m2_height = 3

m1_row_start = 0
m1_col_start = 0

row_1_buffer = ""

jump = systolic_width - 1
total_row_count = 0
row_count = 0

for i in range(0, 10):
    if total_row_count > m1_width - 1:
        row_1_buffer += "0 "
    else:
        row_1_buffer += str(m1[m1_row_start + total_row_count]) + " "

    if row_count == systolic_width - 1:
        row_count = 0
    else:
        row_count += 1

    if (m1_row_start + systolic_width) > m1_width - 1:
        diff = (m1_row_start + systolic_width) - m1_width
        print(row_1_buffer)
        row_1_buffer = ""
        m1_row_start = 0
        m1_col_start += m1_width + m1_width
        total_row_count = 0

print(row_1_buffer)
