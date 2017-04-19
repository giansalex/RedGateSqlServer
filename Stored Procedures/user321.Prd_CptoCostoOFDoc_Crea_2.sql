SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Prd_CptoCostoOFDoc_Crea_2]
@RucE nvarchar(11),
@Cd_OF char(10),
@Id_CCOF int,
--@Cd_Com char(10),
@RegCtb	nvarchar(15), --agregados 
@NroCta	nvarchar(10), --agregados
@CstAsig numeric(15, 7),
@Cd_Mda char(2),
@CamMda decimal(6,3),
@msj varchar(100) output
as
	--if exists (select top 1 * from CptoCostoOFDoc where RucE=@RucE and Cd_OF=@Cd_OF)
	--	set @msj='Registro ya existe'
	--else
	--begin
		insert into CptoCostoOFDoc(RucE,Cd_OF,Id_CCOF,RegCtb,NroCta,CstAsig,Cd_Mda,CamMda) 
		values(@RucE,@Cd_OF,@Id_CCOF,@RegCtb,@NroCta,@CstAsig,@Cd_Mda,@CamMda)
	--end

-----leyenda-----------
--11/02/2012: <Cambio>


GO
