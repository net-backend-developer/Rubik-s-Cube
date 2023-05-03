set nocount on
use AdventureWorks2019

go
create schema RubiksCube
create table RubiksCube.Colors (ColorId tinyint primary key, ColorName varchar(10), Side varchar(5))
create table RubiksCube.BlueTop (RowId tinyint primary key, LeftColor tinyint, MidColor tinyint, RightColor tinyint
	foreign key (LeftColor) references RubiksCube.Colors(ColorId),
	foreign key (MidColor) references RubiksCube.Colors(ColorId),
	foreign key (RightColor) references RubiksCube.Colors(ColorId)
)
create table RubiksCube.OrangeLeft (RowId tinyint primary key, LeftColor tinyint, MidColor tinyint, RightColor tinyint
	foreign key (LeftColor) references RubiksCube.Colors(ColorId),
	foreign key (MidColor) references RubiksCube.Colors(ColorId),
	foreign key (RightColor) references RubiksCube.Colors(ColorId)
)
create table RubiksCube.RedRight (RowId tinyint primary key, LeftColor tinyint, MidColor tinyint, RightColor tinyint
	foreign key (LeftColor) references RubiksCube.Colors(ColorId),
	foreign key (MidColor) references RubiksCube.Colors(ColorId),
	foreign key (RightColor) references RubiksCube.Colors(ColorId)
)
create table RubiksCube.GreenBot (RowId tinyint primary key, LeftColor tinyint, MidColor tinyint, RightColor tinyint
	foreign key (LeftColor) references RubiksCube.Colors(ColorId),
	foreign key (MidColor) references RubiksCube.Colors(ColorId),
	foreign key (RightColor) references RubiksCube.Colors(ColorId)
)
create table RubiksCube.WhiteFront (RowId tinyint primary key, LeftColor tinyint, MidColor tinyint, RightColor tinyint
	foreign key (LeftColor) references RubiksCube.Colors(ColorId),
	foreign key (MidColor) references RubiksCube.Colors(ColorId),
	foreign key (RightColor) references RubiksCube.Colors(ColorId)
)
create table RubiksCube.YellowRear (RowId tinyint primary key, LeftColor tinyint, MidColor tinyint, RightColor tinyint
	foreign key (LeftColor) references RubiksCube.Colors(ColorId),
	foreign key (MidColor) references RubiksCube.Colors(ColorId),
	foreign key (RightColor) references RubiksCube.Colors(ColorId)
)

go
insert RubiksCube.Colors values(1,'White','Front'),(2,'Blue','Top'),(3,'Red','Right'),(4,'Orange','Left'),(5,'Green','Bot'),(6,'Yellow','Rear')
insert RubiksCube.WhiteFront values(1,1,1,1),(2,1,1,1),(3,1,1,1)
insert RubiksCube.BlueTop values(1,2,2,2),(2,2,2,2),(3,2,2,2)
insert RubiksCube.RedRight values(1,3,3,3),(2,3,3,3),(3,3,3,3)
insert RubiksCube.OrangeLeft values(1,4,4,4),(2,4,4,4),(3,4,4,4)
insert RubiksCube.GreenBot values(1,5,5,5),(2,5,5,5),(3,5,5,5)
insert RubiksCube.YellowRear values(1,6,6,6),(2,6,6,6),(3,6,6,6)

go
create type RubiksCube.Side as table(
	RowId tinyint primary key identity,
	LeftColor tinyint not null,
	MidColor tinyint not null,
	RightColor tinyint not null
)

go
create function RubiksCube.GetColor(@ColorId tinyint) returns char(6) as begin
return case @ColorId 
			when 1 then 'White '
			when 2 then ' Blue '
			when 3 then ' Red  '
			when 4 then 'Orange'
			when 5 then 'Green '
			when 6 then 'Yellow'
        end
end

go
create function RubiksCube.AsLine(@left tinyint, @mid tinyint, @right tinyint, @separator varchar(3)) returns char(24) as
begin
  return concat(RubiksCube.GetColor(@left), @separator, RubiksCube.GetColor(@mid), @separator, RubiksCube.GetColor(@right))
end

go
create function RubiksCube.TurnedRight (@source RubiksCube.Side readonly) returns @result table (RowId tinyint, LeftColor tinyint, MidColor tinyint, RightColor tinyint)
as begin 
  insert @result(RowId, RightColor) select 1, LeftColor from @source where RowId=1
  update @result set MidColor = (select LeftColor from @source where RowId=2) where RowId=1
  update @result set LeftColor = (select LeftColor from @source where RowId=3) where RowId=1
  insert @result(RowId, RightColor) select 2, MidColor from @source where RowId=1
  update @result set MidColor = (select MidColor from @source where RowId=2) where RowId=2
  update @result set LeftColor = (select MidColor from @source where RowId=3) where RowId=2
  insert @result(RowId, RightColor) select 3, RightColor from @source where RowId=1
  update @result set MidColor = (select RightColor from @source where RowId=2) where RowId=3
  update @result set LeftColor = (select RightColor from @source where RowId=3) where RowId=3
  return
end

go
create view  RubiksCube.ViewTables ([Left], [Mid], [Right]) as (
select '     ','Blue T','     ' union all
select RubiksCube.GetColor(LeftColor), RubiksCube.GetColor(MidColor), RubiksCube.GetColor(RightColor)
  from RubiksCube.BlueTop
 union all select '     ','White ','     ' union all
select RubiksCube.GetColor(LeftColor), RubiksCube.GetColor(MidColor), RubiksCube.GetColor(RightColor)
  from RubiksCube.WhiteFront
 union all select '     ','Green ','     ' union all
select RubiksCube.GetColor(LeftColor), RubiksCube.GetColor(MidColor), RubiksCube.GetColor(RightColor)
  from RubiksCube.GreenBot
 union all select '     ','Orange','     ' union all
select RubiksCube.GetColor(LeftColor), RubiksCube.GetColor(MidColor), RubiksCube.GetColor(RightColor)
  from RubiksCube.OrangeLeft
  union all select '     ','Red Rt','     ' union all
select RubiksCube.GetColor(LeftColor), RubiksCube.GetColor(MidColor), RubiksCube.GetColor(RightColor)
  from RubiksCube.RedRight
  union all select '     ','Yellow','     ' union all
select RubiksCube.GetColor(LeftColor), RubiksCube.GetColor(MidColor), RubiksCube.GetColor(RightColor)
  from RubiksCube.YellowRear
)

go
create view  RubiksCube.ViewCube ([Cube]) as (
select concat(replicate(' ',27),'| '
             ,RubiksCube.AsLine(LeftColor,MidColor,RightColor,' | ')
             ,' |',replicate(' ',27))
  from RubiksCube.BlueTop
 union all select replicate('-',80) union all
select concat(
       (select RubiksCube.AsLine(LeftColor,MidColor,RightColor,' | ') from RubiksCube.OrangeLeft lo where lo.RowId=fw.RowId)
	  ,'   | '
      ,RubiksCube.AsLine(LeftColor,MidColor,RightColor,' | ')
	  ,' | '
	  ,(select RubiksCube.AsLine(LeftColor,MidColor,RightColor,' | ') from RubiksCube.RedRight lo where lo.RowId=fw.RowId))
  from RubiksCube.WhiteFront fw
 union all select replicate('-',80) union all
select concat(replicate(' ',27),'| '
			 ,RubiksCube.AsLine(LeftColor,MidColor,RightColor,' | '),' |')
  from RubiksCube.GreenBot
 union all select '' union all
select concat(replicate(' ',27),'| '
			 ,RubiksCube.AsLine(LeftColor,MidColor,RightColor,' | '),' |')
  from RubiksCube.YellowRear
)

go
create proc RubiksCube.RightByWhite as
declare @temp RubiksCube.Side;
insert @temp (LeftColor, MidColor, RightColor) select LeftColor, MidColor, RightColor from RubiksCube.BlueTop where RowId=3

update RubiksCube.BlueTop set LeftColor=(select RightColor from RubiksCube.OrangeLeft where RowId=1)  where RowId=3
update RubiksCube.BlueTop set MidColor=(select RightColor from RubiksCube.OrangeLeft where RowId=2)   where RowId=3
update RubiksCube.BlueTop set RightColor=(select RightColor from RubiksCube.OrangeLeft where RowId=3) where RowId=3

update RubiksCube.OrangeLeft set RightColor=(select LeftColor from RubiksCube.GreenBot where RowId=1)  where RowId=1
update RubiksCube.OrangeLeft set RightColor=(select MidColor from RubiksCube.GreenBot where RowId=1)   where RowId=2
update RubiksCube.OrangeLeft set RightColor=(select RightColor from RubiksCube.GreenBot where RowId=1) where RowId=3

update RubiksCube.GreenBot set LeftColor=(select LeftColor from RubiksCube.RedRight where RowId=3)  where RowId=1
update RubiksCube.GreenBot set MidColor=(select LeftColor from RubiksCube.RedRight where RowId=2)   where RowId=1
update RubiksCube.GreenBot set RightColor=(select LeftColor from RubiksCube.RedRight where RowId=1) where RowId=1

update RubiksCube.RedRight set LeftColor=(select LeftColor from @temp)  where RowId=1
update RubiksCube.RedRight set LeftColor=(select MidColor from @temp)   where RowId=2
update RubiksCube.RedRight set LeftColor=(select RightColor from @temp) where RowId=3

declare @centrum RubiksCube.Side
insert @centrum select LeftColor, MidColor, RightColor from RubiksCube.WhiteFront
update t set t.LeftColor=s.LeftColor, t.MidColor=s.MidColor, t.RightColor=s.RightColor
  from RubiksCube.WhiteFront t
  join RubiksCube.TurnedRight(@centrum) s
    on t.RowId = s.RowId

go
create proc RubiksCube.RightByBlue as
declare @temp RubiksCube.Side
insert @temp (LeftColor, MidColor, RightColor) values ((select LeftColor from RubiksCube.WhiteFront where RowId=1)
                                                      ,(select MidColor from RubiksCube.WhiteFront where RowId=1)
													  ,(select RightColor from RubiksCube.WhiteFront where RowId=1))

update RubiksCube.WhiteFront set LeftColor=(select LeftColor from RubiksCube.RedRight where RowId=1) where RowId=1
update RubiksCube.WhiteFront set MidColor=(select MidColor from RubiksCube.RedRight where RowId=1) where RowId=1
update RubiksCube.WhiteFront set RightColor=(select RightColor from RubiksCube.RedRight where RowId=1) where RowId=1

update RubiksCube.RedRight set LeftColor=(select LeftColor from RubiksCube.YellowRear where RowId=3) where RowId=1
update RubiksCube.RedRight set MidColor=(select MidColor from RubiksCube.YellowRear where RowId=3) where RowId=1
update RubiksCube.RedRight set RightColor=(select RightColor from RubiksCube.YellowRear where RowId=3) where RowId=1

update RubiksCube.YellowRear set LeftColor=(select LeftColor from RubiksCube.OrangeLeft where RowId=1) where RowId=3
update RubiksCube.YellowRear set MidColor=(select MidColor from RubiksCube.OrangeLeft where RowId=1) where RowId=3
update RubiksCube.YellowRear set RightColor=(select RightColor from RubiksCube.OrangeLeft where RowId=1) where RowId=3

update RubiksCube.OrangeLeft set LeftColor=(select LeftColor from @temp)  where RowId=1
update RubiksCube.OrangeLeft set MidColor=(select MidColor from @temp)   where RowId=1
update RubiksCube.OrangeLeft set RightColor=(select RightColor from @temp) where RowId=1

declare @centrum RubiksCube.Side
insert @centrum select LeftColor, MidColor, RightColor from RubiksCube.BlueTop
update t set t.LeftColor=s.LeftColor, t.MidColor=s.MidColor, t.RightColor=s.RightColor
  from RubiksCube.BlueTop t
  join RubiksCube.TurnedRight(@centrum) s
    on t.RowId = s.RowId

go
create proc RubiksCube.RightByRed as
declare @temp RubiksCube.Side
insert @temp (LeftColor, MidColor, RightColor) values ((select RightColor from RubiksCube.BlueTop where RowId=3)
                                                      ,(select RightColor from RubiksCube.BlueTop where RowId=2)
													  ,(select RightColor from RubiksCube.BlueTop where RowId=1))

update RubiksCube.BlueTop set RightColor=(select RightColor from RubiksCube.WhiteFront where RowId=1) where RowId=1
update RubiksCube.BlueTop set RightColor=(select RightColor from RubiksCube.WhiteFront where RowId=2) where RowId=2
update RubiksCube.BlueTop set RightColor=(select RightColor from RubiksCube.WhiteFront where RowId=3) where RowId=3

update RubiksCube.WhiteFront set RightColor=(select RightColor from RubiksCube.GreenBot where RowId=1) where RowId=1
update RubiksCube.WhiteFront set RightColor=(select RightColor from RubiksCube.GreenBot where RowId=2) where RowId=2
update RubiksCube.WhiteFront set RightColor=(select RightColor from RubiksCube.GreenBot where RowId=3) where RowId=3

update RubiksCube.GreenBot set RightColor=(select RightColor from RubiksCube.YellowRear where RowId=1) where RowId=3
update RubiksCube.GreenBot set RightColor=(select RightColor from RubiksCube.YellowRear where RowId=2) where RowId=2
update RubiksCube.GreenBot set RightColor=(select RightColor from RubiksCube.YellowRear where RowId=3) where RowId=1

update RubiksCube.YellowRear set RightColor=(select LeftColor from @temp)  where RowId=3
update RubiksCube.YellowRear set RightColor=(select MidColor from @temp)   where RowId=2
update RubiksCube.YellowRear set RightColor=(select RightColor from @temp) where RowId=1

declare @centrum RubiksCube.Side
insert @centrum select LeftColor, MidColor, RightColor from RubiksCube.RedRight
update t set t.LeftColor=s.LeftColor, t.MidColor=s.MidColor, t.RightColor=s.RightColor
  from RubiksCube.RedRight t
  join RubiksCube.TurnedRight(@centrum) s
    on t.RowId = s.RowId

go
create proc RubiksCube.RightByGreen as
declare @temp RubiksCube.Side
insert @temp (LeftColor, MidColor, RightColor) values ((select LeftColor from RubiksCube.WhiteFront where RowId=3)
                                                      ,(select MidColor from RubiksCube.WhiteFront where RowId=3)
													  ,(select RightColor from RubiksCube.WhiteFront where RowId=3))

update RubiksCube.WhiteFront set LeftColor=(select LeftColor from RubiksCube.OrangeLeft where RowId=1) where RowId=3
update RubiksCube.WhiteFront set MidColor=(select MidColor from RubiksCube.OrangeLeft where RowId=1) where RowId=3
update RubiksCube.WhiteFront set RightColor=(select RightColor from RubiksCube.OrangeLeft where RowId=1) where RowId=3

update RubiksCube.OrangeLeft set LeftColor=(select LeftColor from RubiksCube.YellowRear where RowId=1) where RowId=3
update RubiksCube.OrangeLeft set MidColor=(select MidColor from RubiksCube.YellowRear where RowId=1) where RowId=3
update RubiksCube.OrangeLeft set RightColor=(select RightColor from RubiksCube.YellowRear where RowId=1) where RowId=3

update RubiksCube.YellowRear set LeftColor=(select LeftColor from RubiksCube.RedRight where RowId=3) where RowId=1
update RubiksCube.YellowRear set MidColor=(select MidColor from RubiksCube.RedRight where RowId=3) where RowId=1
update RubiksCube.YellowRear set RightColor=(select RightColor from RubiksCube.RedRight where RowId=3) where RowId=1

update RubiksCube.RedRight set LeftColor=(select LeftColor from @temp)  where RowId=3
update RubiksCube.RedRight set MidColor=(select MidColor from @temp)   where RowId=3
update RubiksCube.RedRight set RightColor=(select RightColor from @temp) where RowId=3

declare @centrum RubiksCube.Side
insert @centrum select LeftColor, MidColor, RightColor from RubiksCube.GreenBot
update t set t.LeftColor=s.LeftColor, t.MidColor=s.MidColor, t.RightColor=s.RightColor
  from RubiksCube.GreenBot t
  join RubiksCube.TurnedRight(@centrum) s
    on t.RowId = s.RowId

go
create proc RubiksCube.LeftByGreen as
declare @temp RubiksCube.Side
insert @temp (LeftColor, MidColor, RightColor) values ((select LeftColor from RubiksCube.WhiteFront where RowId=3)
                                                      ,(select MidColor from RubiksCube.WhiteFront where RowId=3)
													  ,(select RightColor from RubiksCube.WhiteFront where RowId=3))

update RubiksCube.WhiteFront set LeftColor=(select LeftColor from RubiksCube.RedRight where RowId=1) where RowId=3
update RubiksCube.WhiteFront set MidColor=(select MidColor from RubiksCube.RedRight where RowId=1) where RowId=3
update RubiksCube.WhiteFront set RightColor=(select RightColor from RubiksCube.RedRight where RowId=1) where RowId=3

update RubiksCube.RedRight set LeftColor=(select LeftColor from RubiksCube.YellowRear where RowId=1) where RowId=3
update RubiksCube.RedRight set MidColor=(select MidColor from RubiksCube.YellowRear where RowId=1) where RowId=3
update RubiksCube.RedRight set RightColor=(select RightColor from RubiksCube.YellowRear where RowId=1) where RowId=3

update RubiksCube.YellowRear set LeftColor=(select LeftColor from RubiksCube.OrangeLeft where RowId=3) where RowId=1
update RubiksCube.YellowRear set MidColor=(select MidColor from RubiksCube.OrangeLeft where RowId=3) where RowId=1
update RubiksCube.YellowRear set RightColor=(select RightColor from RubiksCube.OrangeLeft where RowId=3) where RowId=1

update RubiksCube.OrangeLeft set LeftColor=(select LeftColor from @temp)  where RowId=3
update RubiksCube.OrangeLeft set MidColor=(select MidColor from @temp)   where RowId=3
update RubiksCube.OrangeLeft set RightColor=(select RightColor from @temp) where RowId=3

declare @centrum RubiksCube.Side
insert @centrum select LeftColor, MidColor, RightColor from RubiksCube.GreenBot
update t set t.LeftColor=s.LeftColor, t.MidColor=s.MidColor, t.RightColor=s.RightColor
  from RubiksCube.GreenBot t
  join RubiksCube.TurnedRight(@centrum) s
    on t.RowId = s.RowId

go
exec RubiksCube.RightByRed
select * from RubiksCube.ViewCube
exec RubiksCube.RightByGreen
select * from RubiksCube.ViewCube

go
drop function RubiksCube.GetColor
drop function RubiksCube.AsLine
drop function RubiksCube.TurnedRight 
drop view RubiksCube.ViewTables
drop view RubiksCube.ViewCube
drop proc RubiksCube.LeftByGreen
drop proc RubiksCube.RightByGreen
drop proc RubiksCube.RightByRed
drop proc RubiksCube.RightByBlue
drop proc RubiksCube.RightByWhite
drop type RubiksCube.Side
drop table RubiksCube.BlueTop
drop table RubiksCube.OrangeLeft
drop table RubiksCube.RedRight
drop table RubiksCube.GreenBot
drop table RubiksCube.WhiteFront
drop table RubiksCube.YellowRear
drop table RubiksCube.Colors
drop schema RubiksCube