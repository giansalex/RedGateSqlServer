SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_Prueba]
@RucE nvarchar(11),
@msj varchar(100) output
with encryption
as

select * from venta where RucE=@RucE


--PV : solo prueba
GO
