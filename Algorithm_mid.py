# 10627108 資工三甲 陳文捷

import time # 計時函式

def MaxSubarray( arr ) :
    tmp = [ arr[i] for i in range( len ( arr ) ) ]
    max_ans = arr[0] # 預設這是最大 會因為後面其他數字加入而有影響

    for i in range( 1, len( arr ) ) : # index 0 已經預設為max 接下來做動態調整
        if tmp[i - 1] < 0 : # 前面總和已經是負數 加負數也是一樣小
            tmp[i] = arr[i] # 捨棄原本的 直接換新的
            low = i + 1     # low 改位置
        else :
            tmp[i] = tmp[i - 1] + arr[i]

        if max_ans < tmp[i] : # max < 目前總和
            max_ans = tmp[i]  # update
            high = i + 1      # max 改位置
    # end for
    print( 'Low = %d, High = %d, Sum = %d' %( low, high, max_ans ) )
# end MaxSubarray

# main
while ( True ) :
    arr = [] # arrry of numbers
    n = int ( input ( "Enter size of the array:\n" ) )
    if n == 0 :
        break;

    x = [ int(i) for i in input().split() ] 

    for i in range(0, n) :
        arr.append( x[i] ) # assign number to array

    tStart = time.time() #計時開始
    MaxSubarray( arr )
    tEnd = time.time() #計時結束
    print ( 'It cost %f sec' % ( tEnd - tStart ) )
# end main