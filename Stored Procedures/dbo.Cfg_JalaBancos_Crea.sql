SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[Cfg_JalaBancos_Crea]
@RucEBase nvarchar(11),
@EjerBase varchar(4),
@RucE nvarchar(11),
@Ejer varchar(4)
As


declare @NroCta nvarchar(10)
declare @NCtaB nvarchar(50)
declare @NCorto varchar(6)
declare @Cd_Mda nvarchar(2)
declare @Estado bit
declare @Cd_EF char(2)


declare _Cursor cursor for
select NroCta,NCtaB,NCorto,Cd_Mda,Estado,Cd_EF from Banco where RucE=@RucEBase and Ejer=@EjerBase

Open _Cursor
Fetch Next From _Cursor into @NroCta,@NCtaB,@NCorto,@Cd_Mda,@Estado,@Cd_EF
while @@fetch_status=0
begin

	insert into Banco(RucE,Itm_BC,Ejer,NroCta,NCtaB,NCorto,Cd_Mda,Estado,Cd_EF)
	values	(@RucE,user123.Itm_BC(@RucE),@Ejer,@NroCta,@NCtaB,@NCorto,@Cd_Mda,@Estado,@Cd_EF)

Fetch Next From _Cursor into @NroCta,@NCtaB,@NCorto,@Cd_Mda,@Estado,@Cd_EF
end

Close _Cursor
Deallocate _Cursor
GO
