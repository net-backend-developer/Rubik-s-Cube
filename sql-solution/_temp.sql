create schema RubiksCube
go
create table RubiksCube.Temp (RowId tinyint primary key, LeftColor tinyint, MidColor tinyint, RightColor tinyint)
go
insert RubiksCube.Temp values(1,1,2,3),(2,4,5,6),(3,5,4,3)
--select top(1) sum(LeftColor) over()+sum(MidColor) over()+sum(RightColor) over() from RubiksCube.Temp
select * from RubiksCube.Temp

select LeftColor, MidColor, RightColor
  from RubiksCube.Temp
 group by LeftColor, MidColor, RightColor

select [1] LeftColor, [2] MidColor, [3] RightColor
 from (
   select LeftColor, RowId from RubiksCube.Temp
 ) Src
 pivot (
   max(LeftColor)
   for RowId in ([1],[2],[3])
 ) as PivotTable

 select [3] LeftColor, [2] MidColor, [1] RightColor
 from (
   select LeftColor, RowId from RubiksCube.Temp
 ) Src
 pivot (
   max(LeftColor)
   for RowId in ([1],[2],[3])
 ) as PivotTable

go
drop table RubiksCube.Temp
drop schema RubiksCube