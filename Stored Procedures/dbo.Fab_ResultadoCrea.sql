SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[Fab_ResultadoCrea]

@RucE nvarchar(11),
@Cd_Flujo char(10),
@ID_Prc int,
@Cd_Prod char(7),
@ID_UMP int,
@Cant numeric(15,7),

@msj varchar(100) output
as
declare @ID_Rest int
set @ID_Rest = dbo.ID_Rest(@RucE, @Cd_Flujo, @ID_Prc)

insert into FabResultado(RucE, Cd_Flujo, ID_Prc, ID_Rest, Cd_Prod, ID_UMP, Cant)
	  values(@RucE, @Cd_Flujo, @ID_Prc, @ID_Rest, @Cd_Prod, @ID_UMP, @Cant)

if @@rowcount <= 0
	set @msj = 'Resultado no pudo ser ingresado'
GO
