SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_ProdSustitutoCrea_Import]
@RucE nvarchar(11),
@Cd_ProdB char(7),
@Cd_ProdS char(7),
@Descrip varchar(100),
--@Estado bit,
@msj varchar(100) output
as



/** start -- GG:  Validacion */

	if not exists(select * from  Producto2 where RucE=@RucE and Cd_Prod=@Cd_ProdB )
	begin
		set @msj ='No existe Producto Base: ' + @Cd_ProdB
		return
	end

	if not exists(select * from  Producto2 where RucE=@RucE and Cd_Prod=@Cd_ProdS)
	begin
		set @msj ='No existe Producto Sustituto : ' + @Cd_ProdS
		return
	end

/** end -- GG:  Validacion **/



if exists (select * from ProdSustituto where RucE=@RucE and Cd_ProdB=@Cd_ProdB and Cd_ProdS=@Cd_ProdS)
	set @msj = 'Ya existe sustituto :' + @Cd_ProdS
else
begin
	insert into ProdSustituto(RucE,Cd_ProdB,Cd_ProdS,Descrip,Estado)
	values(@RucE,@Cd_ProdB,@Cd_ProdS,@Descrip,1)
	if @@rowcount <= 0
		set @msj = 'sustituto no pudo ser registrado : ' + @Cd_ProdS
end

-- Leyenda --
-- PP : 2010-03-11 13:42:03 : <Creacion del procedimiento almacenado>
GO
