SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Gsp_TipCamCons_RptMens]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@PrdoD nvarchar(2),
@PrdoH nvarchar(2),
@Cd_Mda nvarchar(2),
@msj varchar(200) output

AS
BEGIN

declare @Ult_FecTC varchar(30)
set @Ult_FecTC= '31/12/2050'


if(ISNULL(@RucE,'')='')
	return

if(ISNULL(@Ejer,'')='')
	return

if(ISNULL(@PrdoD,'')='')
	return
if(ISNULL(@PrdoH,'')='')
	return

if not EXISTS(select *from Empresa e
inner join  Moneda m on m.Cd_Mda=e.Cd_MdaS
inner join  TipCam tc on tc.Cd_Mda=m.Cd_Mda
where e.Ruc=@RucE  and convert(datetime,tc.FecTC,103) < convert(datetime,@Ult_FecTC,103)
	  and year(convert(datetime,tc.FecTC,103))=Convert(int,@Ejer) )
	  begin
	  set @msj = 'No hay cambios del periodo desde:'+@PrdoD+' - hasta:'+@PrdoH  
	  return 
	 end



select  convert(varchar(5),tc.FecTC,103) as 'FecTC',tc.TCVta,TCCom,tc.TCPro,e.RSocial from Empresa e
inner join  Moneda m on m.Cd_Mda=e.Cd_MdaS
inner join  TipCam tc on tc.Cd_Mda=m.Cd_Mda
where e.Ruc=@RucE  and convert(datetime,tc.FecTC,103) < convert(datetime,@Ult_FecTC,103)
	  and year(convert(datetime,tc.FecTC,103))=Convert(int,@Ejer)  and month(convert(datetime,tc.FecTC,103)) between Convert(int,@PrdoD) and Convert(int,@PrdoH) 
order by year(convert(datetime,tc.FecTC,103)) desc ,month(convert(datetime,tc.FecTC,103)) desc,day(convert(datetime,tc.FecTC,103)) desc


END


GO
