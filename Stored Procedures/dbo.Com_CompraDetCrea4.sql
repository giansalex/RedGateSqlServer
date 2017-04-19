SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Com_CompraDetCrea4]
@RucE nvarchar(11),
@Cd_Com char(10),
@Item int,
@Cd_Prod char(7),
@Cd_Srv char(7), 
@Descrip varchar(200),
@ID_UMP int,
@PU numeric (15,4),
@Cant numeric(20,10),
@IMP numeric(15,4),
@IGV numeric(15,4),
@Total numeric(13,2),
@Cd_IA char(1),
@Cd_CC nvarchar(8),
@Cd_SC nvarchar(8),
@Cd_SS nvarchar(8),
@Cd_Alm varchar(20),
@Obs varchar(300),
@UsuMdf nvarchar(10),
@CA01 nvarchar(300),
@CA02 nvarchar(300),
@CA03 nvarchar(50),
@CA04 nvarchar(50),
@CA05 nvarchar(50),
@CA06 nvarchar(50),
@CA07 nvarchar(50),
@CA08 nvarchar(50),
@CA09 nvarchar(50),
@CA10 nvarchar(50),
@ItemOC int,
@msj varchar(100) output,
@IMPTot numeric(13,4),
@IGVTot numeric(13,4)
as
------------------
if(User123.VPrdo(@RucE,(select Ejer from compra where ruce=@RucE and Cd_Com=@Cd_Com),SubString((select RegCtb from compra where ruce=@RucE and Cd_Com=@Cd_Com),8,2)) = 1)
	set @msj = 'El Detalle de Compra no puede ser creado, el periodo '+User123.DamePeriodo(SubString((select RegCtb from compra where ruce=@RucE and Cd_Com=@Cd_Com),8,2))+' no se encuentra habilitado'

------------------
else if exists(select * from CompraDet where RucE=@RucE and Item=@Item  and Cd_Com=@Cd_Com)
	Set @msj = 'Ya existe numero de detalle de compra'
else
begin
	Set @Item = dbo.ItemCD(@RucE,@Cd_Com)
	insert into CompraDet(RucE,Cd_Com,Item,Cd_Prod,Cd_Srv,Descrip,ID_UMP,PU,Cant,IMP,IGV,Total,Cd_IA,
				 Cd_CC,Cd_SC,Cd_SS,Cd_Alm,Obs,FecMdf,UsuModf,CA01,CA02,CA03,CA04,CA05,CA06,CA07,CA08,CA09,CA10,ItemOC,IMPTot,IGVTot)
			values(@RucE,@Cd_Com,@Item,@Cd_Prod,@Cd_Srv,@Descrip,@ID_UMP,@PU,@Cant,@IMP,@IGV,@Total,
			       @Cd_IA,@Cd_CC,@Cd_SC,@Cd_SS,@Cd_Alm,@Obs,GETDATE(),@UsuMdf,@CA01,@CA02,@CA03,@CA04,@CA05,@CA06,@CA07,@CA08,@CA09,@CA10,@ItemOC,@IMPTot,@IGVTot)
	if @@rowcount <= 0
	Set @msj = 'Error al registrar detalle de compra'
declare @Cd_Prv char(7)
declare @Cd_Mda nvarchar(2)
declare @PrecioCom numeric(13,2)
set @Cd_Prv = (select Cd_Prv from Compra where RucE=@RucE and Cd_Com=@Cd_Com)
set @Cd_Mda=(select Cd_Mda from Compra where RucE=@RucE and Cd_Com=@Cd_Com)
set @PrecioCom = @Total/@Cant

if(@Cd_Srv='' or @Cd_Srv is null)
begin

	--Verificacion del ProdProv
	if not exists (select * from ProdProv where RucE=@RucE and Cd_Prv=@Cd_Prv and Cd_Prod=@Cd_Prod and ID_UMP=@ID_UMP)
	begin
		
		insert into ProdProv (RucE,Cd_Prv,Cd_Prod,ID_UMP,CodigoAlt,DescripAlt,Obs,Estado,CA01,CA02,CA03)
				values(@RucE,@Cd_Prv,@Cd_Prod,@ID_UMP,null,null,null,1,null,null,null)
		--exec Com_ProdProvCrea @RucE,@Cd_Prv,@Cd_Prod,@ID_UMP,@CodigoAlt,@DescripAlt,@Obs,1,@CA01,@CA02,@CA03,null
	end
	
	declare @Id_PrecPrv int
	declare @fechaEmi smalldatetime

	set @Id_PrecPrv = dbo.Id_PrecPrv(@RucE)
	set @fechaEmi = (select FecED from compra where RucE = @RucE and CD_Com = @Cd_Com)

	if not exists (select * from ProdProvPrecio where RucE = @RucE and Cd_Prv = @Cd_Prv and Cd_Prod = @Cd_Prod and ID_UMP = @ID_UMP and 
			convert(varchar,Fecha,103) = convert(varchar,@fechaEmi,103))
		insert into ProdProvPrecio(RucE,ID_PrecPrv,Cd_Prv,Cd_Prod,ID_UMP,Fecha,PrecioCom,IB_IncIGV,Cd_Mda,Obs,Estado)
		values(@RucE,@Id_PrecPrv,@Cd_Prv,@Cd_Prod,@ID_UMP,@fechaEmi,@PrecioCom,case(isnull(@IGV,0))
		when 0 then 0 else 1 end,@Cd_Mda,'Registrado de ' + @Cd_Com,1)

	
end
else
begin
	
	--Verificacion del ServProv
	if not exists (select * from ServProv where RucE=@RucE and Cd_Prv=@Cd_Prv and Cd_Srv=@Cd_Srv)
	begin

		insert into ServProv(RucE,Cd_Prv,Cd_Srv,CodigoAlt,DescripAlt,Obs,CA01,CA02,CA03)
				values(@RucE,@Cd_Prv,@Cd_Srv,null,null,null,null,null,null)	
		--exec dbo.Com_ServProvCrea @RucE,@Cd_Prv,@Cd_Srv,null,null,null,null,null,null,null
	end

	declare @ID_PrecSP int
	set @ID_PrecSP = dbo.ID_PrecSP(@RucE)
	--Falta ver como jalar Cd_SP
	insert into ServProvPrecio(RucE,ID_PrecSP,Cd_Prv,Cd_Srv,Fecha,PrecioCom,IB_IncIGV,Cd_Mda,Estado)
			values(@RucE,@ID_PrecSP,@Cd_Prv,@Cd_Srv,GETDATE(),@PrecioCom,case(isnull(@IGV,0))
			when 0 then 0 else 1 end,@Cd_Mda,1)

end
end
-- Leyenda --
-- MM : 11/01/12 (Creacion version 2 : se agrego ItemOC para control de saldos)
--CE: 20/08/2012 Mdf: Antes de eliminar verificar si el periodo esta habilitado en el cierre de periodo
GO
