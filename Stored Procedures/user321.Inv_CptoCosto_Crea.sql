SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [user321].[Inv_CptoCosto_Crea]
@RucE nvarchar(11),
@CodSNT_ varchar(4),
@Descrip varchar(250),
@NCorto varchar(5),
@Estado bit, 
@msj varchar(100) output
as

insert into CptoCosto values (@RucE, dbo.CdCptoCosto(@RucE), @CodSNT_, @Descrip, @NCorto, @Estado)

GO
