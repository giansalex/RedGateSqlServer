SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_ProdComboCrea_Import]
@RucE nvarchar(11),
@Cd_ProdB char(7),
@Cd_ProdC char(7),
@Descrip varchar(100),
@Cant decimal(13,3),
@Id_UMP int,
@msj varchar(100) output
as


/** start -- GG:  Validacion **/
if not exists(select * from  Producto2 where RucE=@RucE and Cd_Prod=@Cd_ProdB ) and (isnull(@Cd_ProdB,'')<>'')
begin
	set @msj ='No existe Producto Base ' +@Cd_ProdB
	return
end

if not exists(select * from  Producto2 where RucE=@RucE and Cd_Prod=@Cd_ProdC ) and (isnull(@Cd_ProdC,'')<>'')
begin
	set @msj ='No existe Producto Combo '+@Cd_ProdC
	return
end

if not exists(select * from  Prod_UM where RucE=@RucE and Cd_Prod=@Cd_ProdC and ID_UMP=@Id_UMP) and (isnull(@Cd_ProdC,'')<>'') and (isnull(@Id_UMP,'')<>'')
begin
	set @msj ='No existe Unidad de medida del Producto Combo '+@Cd_ProdC
	return
end

/** end -- GG:  Validacion **/

if exists (select * from ProdCombo where RucE=@RucE and Cd_ProdB=@Cd_ProdB and Cd_ProdC=@Cd_ProdC and Id_UMP = @Id_UMP)
	set @msj ='El combo ya existe'
else
begin
	insert into ProdCombo(RucE,Cd_ProdB,Cd_ProdC,Descrip,Cant,Id_UMP,Estado)
		   Values(@RucE,@Cd_ProdB,@Cd_ProdC,@Descrip,@Cant,@Id_UMP,1)
	
	if @@rowcount <= 0
	set @msj = 'Combo no puedo ser registrada'
end
print @msj
-- Leyenda --
-- PP : 2010-03-05 : <Creacion del procedimiento almacenado>
GO
