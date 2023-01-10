require 'csv'

puts "1 → 新規でメモを作成する / 2 → 既存のメモを編集する"
 
memo_type = gets.to_i

case memo_type
when 1
    puts "拡張子を除いたファイルを入力してください"
    new_memo = gets.chomp + '.csv'

    if File.exist?(new_memo)
        puts "#{new_memo}は既に存在しているファイルです"
    else
        puts "メモの内容を記入してください\nCtrl+Dで終了します"
        puts "----------------------------------------"

        memo_content = $stdin.read
        memo_oneline = memo_content.split(/\R/)

        CSV.open(new_memo,'w') do |csv|
            memo_oneline.each do |line|
                csv << [line]
            end
        end 

        puts "----------------------------------------"
        puts "#{new_memo}の保存が完了しました"
    end

when 2
    puts "拡張子を除いたファイルを入力してください"
    open_memo = gets.chomp + '.csv'

    if File.exist?(open_memo)
        puts "----------------------------------------"

        CSV.foreach(open_memo) do |line|
            puts line 
        end    

        puts "----------------------------------------"
        puts "1 → メモに追記する / 2 → メモの行を削除する"

        memo_do = gets.to_i

        case memo_do
        when 1
            puts "ファイルの内容を追記してください\nCtrl+Dで終了します"
            puts "----------------------------------------"

            memo_content = $stdin.read
            memo_oneline = memo_content.split(/\R/)

            CSV.open(open_memo,'a') do |csv|
                memo_oneline.each do |line|
                    csv << [line]
                end
            end

            puts "----------------------------------------"
            puts "#{open_memo}の変更を保存しました" 

        when 2
            puts "削除したい行を数字で入力してください"
            input_delete = gets.to_i

            memo_delete = CSV.read(open_memo)
            if (1..memo_delete.length).include?(input_delete)
                memo_delete.delete_at(input_delete - 1)

                CSV.open(open_memo,'w') do |csv|
                    memo_delete.each do |line|
                        csv << line
                    end
                end
                puts "#{open_memo}の#{input_delete}行目の削除を完了しました"

            elsif input_delete > memo_delete.length
                puts "入力した行がメモの行より大きいです"
            else
                puts "1以上の数字を入力してください"
            end
        else
            puts "1か2を入力してください"
        end
    else
        puts "そのファイルは存在していません"
    end
else
    puts "1か2を入力してください"
end