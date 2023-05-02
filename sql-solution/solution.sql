set nocount on
use AdventureWorks2019

go
create schema RubiksCube
create table RubiksCube.Colors (ColorId tinyint primary key, ColorName varchar(10), Side varchar(5))
create table RubiksCube.TopBlue (RowId tinyint primary key, LeftCell tinyint, MidCell tinyint, RightCell tinyint
foreign key (LeftCell) references RubiksCube.Colors(ColorId),
foreign key (MidCell) references RubiksCube.Colors(ColorId),
foreign key (RightCell) references RubiksCube.Colors(ColorId)
)
create table RubiksCube.LeftOrange (RowId tinyint primary key, LeftCell tinyint, MidCell tinyint, RightCell tinyint
foreign key (LeftCell) references RubiksCube.Colors(ColorId),
foreign key (MidCell) references RubiksCube.Colors(ColorId),
foreign key (RightCell) references RubiksCube.Colors(ColorId)
)
create table RubiksCube.RightRed (RowId tinyint primary key, LeftCell tinyint, MidCell tinyint, RightCell tinyint
foreign key (LeftCell) references RubiksCube.Colors(ColorId),
foreign key (MidCell) references RubiksCube.Colors(ColorId),
foreign key (RightCell) references RubiksCube.Colors(ColorId)
)
create table RubiksCube.BotGreen (RowId tinyint primary key, LeftCell tinyint, MidCell tinyint, RightCell tinyint
foreign key (LeftCell) references RubiksCube.Colors(ColorId),
foreign key (MidCell) references RubiksCube.Colors(ColorId),
foreign key (RightCell) references RubiksCube.Colors(ColorId)
)
create table RubiksCube.FrontWhite (RowId tinyint primary key, LeftCell tinyint, MidCell tinyint, RightCell tinyint
foreign key (LeftCell) references RubiksCube.Colors(ColorId),
foreign key (MidCell) references RubiksCube.Colors(ColorId),
foreign key (RightCell) references RubiksCube.Colors(ColorId)
)
create table RubiksCube.RearYellow (RowId tinyint primary key, LeftCell tinyint, MidCell tinyint, RightCell tinyint
foreign key (LeftCell) references RubiksCube.Colors(ColorId),
foreign key (MidCell) references RubiksCube.Colors(ColorId),
foreign key (RightCell) references RubiksCube.Colors(ColorId)
)

go
insert RubiksCube.Colors values(1,'White','Front'),(2,'Blue','Top'),(3,'Red','Right'),(4,'Orange','Left'),(5,'Green','Bot'),(6,'Yellow','Rear ')
insert RubiksCube.FrontWhite values(1,1,1,1),(2,1,1,1),(3,1,1,1)
insert RubiksCube.TopBlue values(1,2,2,2),(2,2,2,2),(3,2,2,2)
insert RubiksCube.RightRed values(1,3,3,3),(2,3,3,3),(3,3,3,3)
insert RubiksCube.LeftOrange values(1,4,4,4),(2,4,4,4),(3,4,4,4)
insert RubiksCube.BotGreen values(1,5,5,5),(2,5,5,5),(3,5,5,5)
insert RubiksCube.RearYellow values(1,6,6,6),(2,6,6,6),(3,6,6,6)

go
create function RubiksCube.Color(@ColorId tinyint) returns varchar(10) as begin
return (select ColorName from RubiksCube.Colors where ColorId=@ColorId)
end

go
with Projection ([Left], [Mid], [Right]) as (
select '     ',' TOP  ','     ' union all
select RubiksCube.Color(LeftCell), RubiksCube.Color(MidCell), RubiksCube.Color(RightCell)
  from RubiksCube.TopBlue
 union all select '     ','FRONT ','     ' union all
select RubiksCube.Color(LeftCell), RubiksCube.Color(MidCell), RubiksCube.Color(RightCell)
  from RubiksCube.FrontWhite
 union all select '     ','BOTTOM','     ' union all
select RubiksCube.Color(LeftCell), RubiksCube.Color(MidCell), RubiksCube.Color(RightCell)
  from RubiksCube.BotGreen
 union all select '======','======','======'
 union all select '     ',' LEFT ','     ' union all
select RubiksCube.Color(LeftCell), RubiksCube.Color(MidCell), RubiksCube.Color(RightCell)
  from RubiksCube.LeftOrange
 union all select '======','======','======'
 union all select '     ','RIGHT ','     ' union all
select RubiksCube.Color(LeftCell), RubiksCube.Color(MidCell), RubiksCube.Color(RightCell)
  from RubiksCube.RightRed
) select * from Projection

go
create proc RubiksCube.FrontRotationRight as
declare @temp table (LeftCell tinyint, MidCell tinyint, RightCell tinyint)
insert @temp (LeftCell, MidCell, RightCell) select LeftCell, MidCell, RightCell from RubiksCube.TopBlue
update RubiksCube.RightRed set LeftCell=LeftCell where RowId=1 select LeftCell from @temp
update RubiksCube.RightRed set LeftCell=LeftCell where RowId=2 select MidCell from @temp
update RubiksCube.RightRed set LeftCell=LeftCell where RowId=3 select RightCell from @temp

go
drop function RubiksCube.Color
drop proc RubiksCube.FrontRotationRight
drop table RubiksCube.TopBlue
drop table RubiksCube.LeftOrange
drop table RubiksCube.RightRed
drop table RubiksCube.BotGreen
drop table RubiksCube.FrontWhite
drop table RubiksCube.RearYellow
drop table RubiksCube.Colors
drop schema RubiksCube