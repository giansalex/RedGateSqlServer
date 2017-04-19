SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Com_SolicitudComCons_explo] --<Explorador de Solicitud de Compras>
--exec dbo.Com_SolicitudComCons_explo '11111111111','2010','00','05','Cd_SC','0001',null
@RucE nvarchar(11),
@Ejer nvarchar(4),
@PrdoD nvarchar(2),
@PrdoH nvarchar(2),
@Colum varchar(100),
@Dato varchar(100),
@msj varchar(100) output
as

Declare @Cond varchar(200)
Set @Cond = ''

if(@Colum = 'Cd_SC') 
	Set @Cond = ' and sc.Cd_SC like '+'''%'+@Dato+'%'''
else if(@Colum = 'NroSC') 
	Set @Cond = ' and sc.NroSC like '+'''%'+@Dato+'%'''
else if(@Colum = 'FecEmi') 
	Set @Cond = ' and Convert(nvarchar,sc.FecEmi,103) like '+'''%'+@Dato+'%'''
else if(@Colum = 'FecEntR') 
	Set @Cond = ' and Convert(nvarchar,sc.FecEntR,103) like '+'''%'+@Dato+'%'''
else if(@Colum = 'Cd_FPC') 
	Set @Cond = ' and sc.Cd_FPC like '+'%'+@Dato+'%'
else if(@Colum = 'Asunto') 
	Set @Cond = ' and sc.Asunto like '+'''%'+@Dato+'%'''
else if(@Colum = 'Cd_Area') 
	Set @Cond = ' and sc.Cd_Area like '+'''%'+@Dato+'%'''
else if(@Colum = 'Obs') 
	Set @Cond = ' and sc.Obs like '+'''%'+@Dato+'%'''
else if(@Colum = 'ElaboradoPor') 
	Set @Cond = ' and sc.ElaboradoPor like '+'''%'+@Dato+'%'''
else if(@Colum = 'AutorizadoPor') 
	Set @Cond = ' and sc.AutorizadoPor like '+'''%'+@Dato+'%'''
else if(@Colum = 'FecReg') 
	Set @Cond = ' and sc.FecReg like '+'''%'+@Dato+'%'''
else if(@Colum = 'FecMdf') 
	Set @Cond = ' and sc.FecMdf like '+'''%'+@Dato+'%'''
else if(@Colum = 'UsuCrea') 
	Set @Cond = ' and sc.UsuCrea like '+'''%'+@Dato+'%'''
else if(@Colum = 'UsuMdf') 
	Set @Cond = ' and sc.UsuMdf like '+'''%'+@Dato+'%'''
else if(@Colum = 'Id_EstSC') 
	Set @Cond = ' and sc.Id_EstSC like '+'''%'+@Dato+'%'''

print 'Cadena = '+@Cond

Declare @CONSULTA nvarchar(4000)
Set @CONSULTA='	select 
			sc.Cd_SC,
			sc.NroSC,
			Convert(nvarchar,sc.FecEmi,103) as FecEmi,
			Convert(nvarchar,sc.FecEntR,103) as FecEntR,
			sc.Cd_FPC,
			sc.Asunto,
			sc.Cd_Area,
			sc.Obs,
			sc.ElaboradoPor,
			sc.AutorizadoPor,
			sc.FecReg,
			sc.FecMdf,
			sc.UsuCrea,
			sc.UsuMdf,
			sc.Id_EstSC		
		from SolicitudCom sc
		left join FormaPC f on f.Cd_FPC=sc.Cd_FPC
		left join Area a on a.RucE=sc.RucE and a.Cd_Area=sc.Cd_Area
		left join EstadoSC s on s.Id_EstSC=sc.Id_EstSC
		where sc.RucE='''+@RucE+''' and year(sc.FecEmi)='''+@Ejer+''' and Month(sc.FecEmi) between convert(int,'''+@PrdoD+''') and convert(int,'''+@PrdoH+''')
	       '+@Cond
Print @CONSULTA
Exec (@CONSULTA)

-- LEYENDA --
-- J : 26/04/2010 <Creacion del procedimiento almacenado>
GO
