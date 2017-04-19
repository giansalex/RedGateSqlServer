SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_VerificaConexionEntreDocumentos]
@RucE nvarchar(11),
@Cd_Com nvarchar(10),
@Cd_Vta nvarchar(10),
@Cd_OC nvarchar(10),
@Cd_OP nvarchar(10),
@Cd_GR char(10),
@Cd_SR char(10),
@Cd_OF char(10),
@msj varchar(100) output
--with encryption
as
declare @Cd_TDES char(2)
-------------------  C O M P R A   ----------------------
if(@Cd_Com != '' or @Cd_Com is not null)
begin
	--declare @Cd_OC nvarchar(10),@Cd_TDES char(2)
	select @Cd_OC = Cd_OC from Compra  where RucE = @RucE and Cd_Com = @Cd_Com
	print @Cd_OC
	if exists (select * from Inventario where RucE = @RucE and Cd_Com in (select Cd_Com from Compra where RucE = @RucE and Cd_OC = @Cd_OC) )
	begin
		select Top 1 @Cd_TDES = Cd_TDES from Inventario where RucE = @RucE and Cd_OC = @Cd_OC
		if(@Cd_TDES = 'OC')
		begin
			set @msj = 'No se puede jalar la Compra.'
			print 'No se puede jalar la Compra.'
		end
	end
	else
	print 'Si se puede jalar la Compra.'


	/*select @Cd_OC = Cd_OC from Compra  where RucE = @RucE and Cd_Com = @Cd_Com
	--select * from Inventario where RucE = @RucE and Cd_OC = @Cd_OC
	if exists (select * from Inventario where RucE = @RucE and Cd_Com in (select Cd_Com from Compra where RucE = @RucE and Cd_OC = @Cd_OC) )
	begin
		set @msj = 'No se puede jalar la Compra.'
		print @msj
	end*/
end
else
--------------------- V E N T A -------------------------
if(@Cd_Vta != '' or @Cd_Vta is not null)
begin
	set @msj = 'En Construccion'
end
else
------------- O R D E N     DE    C O M P R A --------------
if(@Cd_OC != '' or @Cd_OC is not null)
begin
	--select @Cd_Com = Cd_Com from Compra where RucE = @RucE and Cd_OC = @Cd_OC
	if exists (select * from Inventario where RucE = @RucE and Cd_Com in (select Cd_Com from Compra where RucE = @RucE and Cd_OC = @Cd_OC))
	begin
		--select Top 1 @Cd_TDES = Cd_TDES  from Inventario where RucE = @RucE and Cd_OC = @Cd_OC
		select Top 1 @Cd_TDES = Cd_TDES from Inventario where RucE = @RucE and Cd_Com in (select Cd_Com from Compra where RucE = @RucE and Cd_OC = @Cd_OC)
		if(@CD_TDES = 'CP')
		begin
			set @msj = 'No se puede jalar la O.C.'
			print @msj
		end
	end
end
else
------------- O R D E N    D E    P E D I D O ----------
if(@Cd_OP != '' or @Cd_OP is not null)
begin
	set @msj = 'En Construccion'
end
else
------------------ G U I A    R E M I S I O N -------------------
if(@Cd_GR != '' or @Cd_GR is not null)
begin
	-- PARA ENTRADAS
	if (select IC_ES from GuiaRemision where RucE = @RucE and Cd_GR = @Cd_GR) = 'E'
	begin
		set @msj = 'En Construccion'
	end
	else --PARA SALIDAS
	begin
		set @msj = 'En Construccion'
	end
end
------------- S O L I C I T U D    D E   R E Q U E R I M I E N T O ----------
else if(@Cd_SR != '' or @Cd_SR is not null)
begin
	set @msj = 'En Construccion'
end
----------------  O R D E N    D E    F A B R I C A C I O N  --------------
else if(@Cd_OF != '' or @Cd_OF is not null)
begin
	set @msj = 'En Construccion'
end

-- CAM <Fecha: 03/08/2010><Creacion del sp>

--exec Inv_VerificaConexionEntreDocumentos '11111111111',null,null,'OC00000158',null,null,null,null,null
-- exec Inv_VerificaConexionEntreDocumentos '11111111111','CM00000305',null,null,null,null,null,null,null
/*
declare @Cd_OC nvarchar(10)
set @Cd_OC = null
exec Inv_VerificaConexionEntreDocumentos '11111111111','CM00000305',null,@Cd_OC Output,null,null,null,null,null
print @Cd_OC
*/
GO
