function Sudoku

%------------
%Sudoku
%Version 1.01
%Created by Stepen
%Created 11 May 2011
%Last modified 19 October 2011
%------------
%Sudoku starts a GUI for Sudoku game or for Sudoku solver
%------------
%How to play Sudoku:
%Player fills a number from 1 to 9 into given empty space with a rule that
%no number is appear twice in a single row, column, and minigrid. To play a
%game of Sudoku, click PlayGame button and an incomplete board of Sudoku
%will be created in the grid box. Use CheckBoard button to check whether
%there is a violation in the board. To solve an incomplete Sudoku board,
%fill the grid box with the corresponding number and click SolveSudoku
%button. Remember to click ResetBoard before starting a new game or
%entering an incomplete board to be solved.
%------------

%CodeStart
%Reseting MATLAB environment
    close all
    clear all
%Declaring global variable
    board=zeros(9);
    stat=zeros(9);
%Generating GUI
    ScreenSize=get(0,'ScreenSize');
    mainwindow=figure('Name','Sudoku',...
                      'NumberTitle','Off',...
                      'Resize','off',...
                      'Menubar','none',...
                      'Units','pixels',...
                      'Position',[0.5*(ScreenSize(3)-384),...
                                  0.5*(ScreenSize(4)-400),...
                                  384,400]);
    GUIboard=zeros(9);
    for i=1:9
        for j=1:9
            vc=(ceil(j/3)-2)*0.0125;
            hc=(ceil(i/3)-2)*0.0125;
            GUIboard(i,j)=uicontrol('Parent',mainwindow,...
                                 'Style','edit',...
                                 'String','',...
                                 'Enable','On',...
                                 'Units','normalized',...
                                 'Position',[0.0925+0.075*i+hc,...
                                             0.975-0.075*j-vc,...
                                             0.075,0.075]);
        end
    end
    uicontrol('Parent',mainwindow,...
              'Style','pushbutton',...
              'String','PlayGame(Easy)',...
              'Units','normalized',...
              'Position',[0.1,0.2,0.25,0.05],...
              'Callback',@startgameeasyfcn);
    uicontrol('Parent',mainwindow,...
              'Style','pushbutton',...
              'String','PlayGame(Normal)',...
              'Units','normalized',...
              'Position',[0.375,0.2,0.25,0.05],...
              'Callback',@startgamenormalfcn);
    uicontrol('Parent',mainwindow,...
              'Style','pushbutton',...
              'String','PlayGame(Hard)',...
              'Units','normalized',...
              'Position',[0.65,0.2,0.25,0.05],...
              'Callback',@startgamehardfcn);
    uicontrol('Parent',mainwindow,...
              'Style','pushbutton',...
              'String','CheckBoard',...
              'Units','normalized',...
              'Position',[0.1,0.12,0.25,0.05],...
              'Callback',@checkboardfcn);
    uicontrol('Parent',mainwindow,...
              'Style','pushbutton',...
              'String','ResetBoard',...
              'Units','normalized',...
              'Position',[0.375,0.12,0.25,0.05],...
              'Callback',@resetboardfcn);
    uicontrol('Parent',mainwindow,...
              'Style','pushbutton',...
              'String','SolveSudoku',...
              'Units','normalized',...
              'Position',[0.65,0.12,0.25,0.05],...
              'Callback',@solvesudokufcn);
    instructionbox=uicontrol('Parent',mainwindow,...
                              'Style','text',...
                              'String','Welcome to Sudoku!',...
                              'Units','normalized',...
                              'Position',[0.05,0.025,0.9,0.04]);
%Declaring LocalFunction
    %Start of readGUIboard
    function board=readGUIboard
        board=zeros(9);
        for row=1:9
        for col=1:9
            value=str2double(get(GUIboard(row,col),'String'));
            if isnan(value)
                board(row,col)=0;
            else
                board(row,col)=value;
            end
        end
        end
    end
    %End of readGUIboard
    %Start of display2GUIboard
    function display2GUIboard(board)
        for row=1:9
        for col=1:9
            if board(row,col)~=0
                set(GUIboard(row,col),'String',num2str(board(row,col)))
            else
                set(GUIboard(row,col),'String','')
            end
            set(GUIboard(row,col),'BackGroundColor','w')
        end
        end
    end
    %End of display2GUIboard
    %Start of lockGUIboard
    function lockGUIboard(board)
        for row=1:9
        for col=1:9
            if board(row,col)==0
                set(GUIboard(row,col),'Enable','On')
            else
                set(GUIboard(row,col),'Enable','Off')
            end
        end
        end
    end
    %End of lockGUIboard
    %Start of checkboard
    %Generating status array
    function stat=checkboard(board)
        stat=false(9);
        %Performing violation checking
        for testvalue=1:9
            %Checking for violation in rows
            for row=1:9
                if sum(sum(board(row,:)==testvalue))>1
                    errorloc=(board(row,:)==testvalue);
                    stat(row,:)=stat(row,:)|errorloc;
                end
            end
            %Checking for violation in columns
            for col=1:9
                if sum(sum(board(:,col)==testvalue))>1
                    errorloc=(board(:,col)==testvalue);
                    stat(:,col)=stat(:,col)|errorloc;
                end
            end
            %Checking for violation in minigrid
            for gcrow=[1,2,3]
            for gccol=[1,2,3]
                if sum(sum(board(3*gcrow-2:3*gcrow,3*gccol-2:3*gccol)...
                           ==testvalue))>1
                    errorloc=(board(3*gcrow-2:3*gcrow,3*gccol-2:3*gccol)...
                              ==testvalue);
                    stat(3*gcrow-2:3*gcrow,3*gccol-2:3*gccol)=...
                          (stat(3*gcrow-2:3*gcrow,3*gccol-2:3*gccol)|...
                          errorloc);
                end
            end
            end
        end
    end
    %End of checkboard
    %Start of markGUIboard
    function markGUIboard(stat)
        for row=1:9
        for col=1:9
            if stat(row,col)==1
                set(GUIboard(row,col),'BackGroundColor','r')
            else
                set(GUIboard(row,col),'BackGroundColor','w')
            end
        end
        end
    end
    %End of markGUIboard
    %Start of deleteGUIboard
    function board=deleteGUIboard(board,delcount)
        count=0;
        while count<delcount
            temp=ceil(rand*81);
            if board(temp)~=0
                board(temp)=0;
                count=count+1;
            end
        end
    end
    %End of deleteGUIboard
%Declaring CallbackFunction
    %Start of startgameeasyfcn
    function startgameeasyfcn(~,~)
        board=SudokuSolver;
        board=deleteGUIboard(board,20);
        display2GUIboard(board)
        lockGUIboard(board)
        set(instructionbox,'String','Easy Sudoku Puzzle')
    end
    %End of startgameeasyfcn
    %Start of startgamenormalfcn
    function startgamenormalfcn(~,~)
        board=SudokuSolver;
        board=deleteGUIboard(board,40);
        display2GUIboard(board)
        lockGUIboard(board)
        set(instructionbox,'String','Normal Sudoku Puzzle')
    end
    %End of startgamenormalfcn
    %Start of startgamehardfcn
    function startgamehardfcn(~,~)
        board=SudokuSolver;
        board=deleteGUIboard(board,60);
        display2GUIboard(board)
        lockGUIboard(board)
        set(instructionbox,'String','Hard Sudoku Puzzle')
    end
    %End of startgamehardfcn
    %Start of checkboardfcn
    function checkboardfcn(~,~)
        %Reading board
        tempboard=readGUIboard;
        %Checking board
        stat=checkboard(tempboard);
        %Mark GUI board for mistakes
        markGUIboard(stat)
        if sum(sum(stat))==0
            if sum(sum(tempboard==0))==0
                set(instructionbox,'String','Puzzle Solved!')
            else
                set(instructionbox,'String',...
                    'No violation detected! Keep going!')
            end
        else
            set(instructionbox,'String',...
                'Violation detected! Recheck the board!')
        end
    end
    %End of checkboardfcn
    %Start of resetboardfcn
    function resetboardfcn(~,~)
        board=zeros(9);
        display2GUIboard(board)
        lockGUIboard(board)
        set(instructionbox,'String','Board reseted!')
    end
    %End of resetboardfcn
    %Start of solvesudokufcn
    function solvesudokufcn(~,~)
        tempboard=readGUIboard;
        stat=checkboard(tempboard);
        if sum(sum(stat))==0
            result=SudokuSolver(tempboard);
            display2GUIboard(result)
            set(instructionbox,'String','Puzzle Solved!')
        else
            markGUIboard(stat)
            set(instructionbox,'String',...
                'Puzzle unsolvable due to violation!')
        end
    end
    %End of solvesudokufcn
%CodeEnd-------------------------------------------------------------------

end