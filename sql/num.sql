CREATE function num(@lo int, @hi int) returns table as RETURN (
  select convert(int, (row_number() over(order by (select 1)))+@lo-1) n
  from string_split(replicate(
  convert(varchar(max),' '),
    (select
     case when (@hi-@lo) >0
     then
          case when (@hi-@lo+1) < ma.x
          then (@hi-@lo)
          else ma.x
          end
    else 0
    end num
    from (select 2147483647 x) ma
    )
  ), ' ') v
)