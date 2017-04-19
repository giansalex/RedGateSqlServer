SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[Fab_InsumoCrea]

@RucE nvarchar(11),
@Cd_Flujo char(10),
@ID_Prc int,
@Cd_Prod char(7),
@ID_UMP int,
@Cant numeric(15,7),
@Merma numeric(15,7),

@msj varchar(100) output
as
declare @ID_Ins int
set @ID_Ins = dbo.ID_Ins(@RucE, @Cd_Flujo, @ID_Prc)

insert into FabInsumo(RucE, Cd_Flujo, ID_Prc, ID_Ins, Cd_Prod, ID_UMP, Cant, Merma)
	  values(@RucE, @Cd_Flujo, @ID_Prc, @ID_Ins, @Cd_Prod, @ID_UMP, @Cant, @Merma)

if @@rowcount <= 0
	set @msj = 'Insumo no pudo ser ingresado'
GO
