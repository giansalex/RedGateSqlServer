SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[Gsp_TasaHistCrea]
@Cd_Ts nvarchar(3),
@EjerPrdoVig nchar(10),
@Porc numeric(6,3),
@msj varchar(100) output
as



if exists (select * from TasasHist Where Cd_Ts=@Cd_Ts and EjerPrdoVig=@EjerPrdoVig)
	set @msj='Ud. ya registro una tasa para este periodo.'
else 
Begin
	insert into TasasHist(Cd_Ts,EjerPrdoVig,Porc)
	values(@Cd_Ts,@EjerPrdoVig,@Porc)
End
GO
