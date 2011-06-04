#!/usr/bin/ruby
                                                               
                                                 
require "mini_exiftool"

if defined? "ARGV" then path = ARGV end

def showExif(path = ".")
  result = Hash.new
  images = Dir.glob("#{path}/**/*.{jpg,JPG,Jpg,GIF,Gif,gif,CR2}")     
  puts "Images: #{images.length}"                   
  counter = Hash.new
  counter['all'] = 0
  counter['tagged'] = 0
  counter['nottagged'] = 0

  File.open("photostats.txt", 'w')
  File.open("photostats.txt", 'a') {|x| x.write("Tagged; All; Model; Year; Month; Size; Type\n") }

  images.each do|f|  

   photo = MiniExiftool.new f
   
     if photo.error.nil? && !photo['model'].nil?
       puts "<"
#       output = "Tagged; All; Model; Year; Month; Size; Type\n"                     
       print "[#{counter['tagged']}] \t [#{counter['all']}]" 
       output = "#{counter['tagged']};#{counter['all']};"
       print "\t[Model]: #{photo['model']}"
       output << "#{photo['model']};" 
       if photo['DateTimeOriginal'] 
          print "\t[Year]: #{photo['DateTimeOriginal'].year}" 
          print "\t[Month]: #{photo['DateTimeOriginal'].month}"           
          output << "#{photo['DateTimeOriginal'].year};#{photo['DateTimeOriginal'].month};"
       else
          print "\t[Year/Month]: No!"              
          output << "-;-;"
       end                
       pwidth = photo['Imagesize'].split('x')[0].to_i
       pheight = photo['Imagesize'].split('x')[1].to_i
       pixels = pwidth*pheight
       print "\t[Size]: #{pixels}(#{photo['Imagesize']})"
       output << "#{pixels};"
       print "\t[Type]: #{photo['mimetype'].split('/')[1]}"
       output << "#{photo['mimetype'].split('/')[1]};\n"             
       File.open("photostats.txt", 'a') {|x| x.write("#{output}") }  
       counter['tagged'] += 1                 
     else  
  #    model = EXIFR::JPEG.new(f).model.to_s
  #    date = EXIFR::JPEG.new(f).date_time_original
  #    if !model.empty? then
  #      output = "#{counter['gapless']};#{counter['tagged']};#{model};#{date};#{f}\n"
  #    File.open("exifresult.txt", 'a') {|f| f.write("#{output}") }
  #       puts "\t=>#{output}"  
  #       puts "\t=>done"
  #     result [f] = model, date
  #      counter['tagged'] += 1 
        counter['nottagged'] +=1                                   
     end                                                           
  counter['all'] += 1
  end                                             

  puts "\nAll: #{counter['all']} (Tagged: #{counter['tagged']} | Not Tagged: #{counter['nottagged']})"
  
  
  result.sort.each { |i| print i, "\n"} 
   

  
  
end                                        


showExif

