clear all
directories = {'cricket_batting','cricket_bowling','croquet','tennis_forehand','tennis_serve','volleyball_smash'};
nmatf = {1:3,4:5,6:8,9:10,11:12,13:14};
matfiles = {'batting_bat','batting_ball','batting_stumps','bowling_ball','bowling_stumps','croquet_mallet','croquet_ball','croquet_hoop','forehand_ball','forehand_racquet','serve_ball','serve_racquet','smash_ball','smash_net'};
warning off;


for d=1:6

directory = ['./' directories{d} '/'];

for t=1:numel(nmatf{d})
    load(['object_annotations/' matfiles{nmatf{d}(t)}])
    O{t} = object;
    clear object;
end

for f=1:30
      disp(['Showing'  num2str(f)]);
      im = imread([directory 'train/image' num2str(f,'%02d') '.png']);
      silIm = imread([directory 'silh/sil' num2str(f,'%02d') '.png']);
      %im(silIm==255) = im(silIm==255)*0.2;
      subplot(1,2,1);
      imshow(im);
      subplot(1,2,2);
      imshow(silIm);
      subplot(1,2,1);
      hold on;
      for t=1:numel(nmatf{d})
      n = 1;
      while 1
          if O{t}{f}(n,3)==0 && O{t}{f}(n,4)==0
              break
          end
          plot([O{t}{f}(n,1) O{t}{f}(n,1)+O{t}{f}(n,3)],[O{t}{f}(n,2) O{t}{f}(n,2)],'linewidth',3);
          plot([O{t}{f}(n,1)+O{t}{f}(n,3) O{t}{f}(n,1)+O{t}{f}(n,3)],[O{t}{f}(n,2) O{t}{f}(n,2)+O{t}{f}(n,4)],'linewidth',3);
          plot([O{t}{f}(n,1) O{t}{f}(n,1)+O{t}{f}(n,3)],[O{t}{f}(n,2)+O{t}{f}(n,4) O{t}{f}(n,2)+O{t}{f}(n,4)],'linewidth',3);
          plot([O{t}{f}(n,1) O{t}{f}(n,1)],[O{t}{f}(n,2) O{t}{f}(n,2)+O{t}{f}(n,4)],'linewidth',3);
          
          n = n+1;
      end
      end
      

      pause();
      
      hold off;
end

end
warning on;