SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_NroSrCons]
@RucE nvarchar(11),
@Cd_TD nvarchar(4),
@msj varchar(100) output
as
begin
select * from Serie s
inner join Numeracion n on n.Cd_Sr=s.Cd_Sr and n.RucE=s.RucE
where s.RucE=@RucE and (Cd_TD=@Cd_TD or Cd_TD=@Cd_TD)
if @@rowcount <= 0
	   set @msj = 'Serie no pudo ser consultado'
end
print @msj
-- Leyenda --
-- FL : 2010-09-02 : <Modificacion del procedimiento almacenado>


GO
