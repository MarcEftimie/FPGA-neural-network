m1 = [1, 2, 3, 4, 5, 6, 7, 8, 9]
m2 = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16]

systolic_width = 2

m1_width = 3
m1_height = 4

m2_width = 4
m2_height = 4

m1_row_start = 0
m1_col_start = 0
m2_square = 0


for i in range(0, 4):
    if (m1_row_start + systolic_width) > m1_width - 1:
        diff = (m1_row_start + systolic_width) - m1_width
        print(
            m1[
                m1_row_start
                + m1_col_start : m1_row_start
                + m1_col_start
                + systolic_width
                - diff
            ]
            + diff * [0]
            + m1[
                m1_row_start
                + m1_col_start
                + m1_width : m1_row_start
                + m1_col_start
                + m1_width
                + systolic_width
                - diff
            ]
            + diff * [0]
        )
        m1_row_start = 0
        m1_col_start += m1_width + m1_width
    else:
        print(
            m1[
                m1_row_start
                + m1_col_start : m1_row_start
                + m1_col_start
                + systolic_width
            ]
            + m1[
                m1_row_start
                + m1_col_start
                + m1_width : m1_row_start
                + m1_col_start
                + m1_width
                + systolic_width
            ]
        )
    m1_row_start += systolic_width
