SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Com_OrdCompra_ConsOrd]
@RucE nvarchar(11),
@Colum nvarchar(15),
@EstaAut bit,
@msj varchar(100) output
as
begin
declare @consulta varchar(8000)
IF(@RucE = '20504743561') set @EstaAut = 0 -- SI ES GMC SE MUESTRAN TODAS LAS OC
IF(@EstaAut=1)
BEGIN
set @consulta =
'select convert(Nvarchar, co.FecE,103) as FecMov,co.NroOC as NroDoc,
case(co.Cd_Mda) when ''01'' then co.Total else convert(numeric(13,2),co.Total*co.CamMda) end  as Soles ,
case(co.Cd_Mda) when ''01'' then convert(numeric(13,2), co.Total/co.CamMda) else co.Total end as Dolares ,
case(co.Cd_Mda) when ''01'' then ''S/.'' else ''$'' end as Mda,co.CamMda,co.Cd_OC as CodMov,
convert(Nvarchar,co.FecE,103) as FecED from OrdCompra co
where co.IB_Aut=1 and co.RucE = '''+@RucE+''' and Cd_OC in(select Cd_OC from OrdCompraDet where RucE = '''+@RucE+''' 
/*and Cd_Prod is not null*/ group by Cd_OC) and co.Id_EstOC in (''01'',''02'')
--order by convert(Nvarchar,  co.FecMov,102) desc
order by '+@Colum+' desc'
print @consulta
exec (@consulta)
END
ELSE IF(@EstaAut=0)
BEGIN
set @consulta =
'select convert(Nvarchar, co.FecE,103) as FecMov,co.NroOC as NroDoc,
case(co.Cd_Mda) when ''01'' then co.Total else convert(numeric(13,2),co.Total*co.CamMda) end  as Soles ,
case(co.Cd_Mda) when ''01'' then convert(numeric(13,2), co.Total/co.CamMda) else co.Total end as Dolares ,
case(co.Cd_Mda) when ''01'' then ''S/.'' else ''$'' end as Mda,co.CamMda,co.Cd_OC as CodMov,
convert(Nvarchar,co.FecE,103) as FecED from OrdCompra co
where co.RucE = '''+@RucE+''' and Cd_OC in(select Cd_OC from OrdCompraDet where RucE = '''+@RucE+''' 
/*and Cd_Prod is not null*/ group by Cd_OC) and co.Id_EstOC in (''01'',''02'')
--order by convert(Nvarchar,  co.FecMov,102) desc
order by '+@Colum+' desc'
print @consulta
exec (@consulta)
END

end
print @msj
--exec Com_OrdCompra_ConsOrd '11111111111','FecE',0,null
-- Leyenda --
-- FL : 19/04/11 : <Creacion del procedimiento almacenado>

GO
