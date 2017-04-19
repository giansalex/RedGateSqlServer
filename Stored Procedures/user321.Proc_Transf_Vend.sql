SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Proc_Transf_Vend]
@RucE nvarchar(11)
as

declare @Consulta varchar(4000)

set @Consulta='
declare @Cd_Vdr char(7)
declare @Cd_TDI	nvarchar(2)
declare @NDoc varchar(15)
declare @RSocial varchar(150)
declare @ApPat varchar(20)
declare @ApMat varchar(20)
declare @Nom varchar(20)
declare @Cd_Pais nvarchar(4)
declare @Ubigeo	nvarchar(6)
declare @Direc varchar(100)
declare @Telf1 varchar(20)
declare @Telf2 varchar(20)
declare @Correo	varchar(50)
declare @Obs varchar(200)
declare @Estado	bit
declare @CA01 varchar(100)
declare @CA02 varchar(100)
declare @CA03 varchar(100)
declare @CA04 varchar(100)
declare @CA05 varchar(100)
declare @CA06 varchar(100)
declare @CA07 varchar(100)
declare @CA08 varchar(100)
declare @CA09 varchar(300)
declare @CA10 varchar(300)
declare @Cd_Aux varchar(100)
declare @Cta nvarchar(10)

Declare _cursor Cursor 
	For  SELECT 
	Cd_Aux,	Cd_TDI, NDoc, RSocial, ApPat, ApMat, Nom, case when len(Cd_Pais)=0 then ''9589'' else ''9589'' end as Cd_Pais, 
	Ubigeo, Direc, Telf1, Telf2, Correo, Obs, Estado, CA01, CA02, CA03, CA04, CA05, CA06, CA07, CA08, CA09, CA10, Cta
from 
	OPENROWSET(''SQLOLEDB'',''netserver'';''Usu123_1'';''user123'',
	''select 
		a.*,case when v.Cta is null then ''''9999999999'''' else Cta end as Cta
	from 
		Auxiliar a left join Vendedor v on v.RucE=a.RucE and v.Cd_Aux=a.Cd_Aux
	where 
		a.RucE='''''+@RucE+''''' 
		and a.Cd_Aux in 
		(SELECT 
			a.Cd_Aux
		FROM 
			Venta v inner join Auxiliar a
			on a.RucE=v.RucE and a.Cd_Aux=v.Cd_Vdr
		where 
			len(v.Cd_Vdr)<>0 and v.RucE='''''+@RucE+''''' 
		group by
			a.Cd_Aux) '')
	      --where 
		--Cd_TDI+''''+NDoc not in(select Cd_TDI+''''+NDoc from Vendedor2 where RucE='''+@RucE+''') and RucE='''+@RucE+'''

Open _cursor
	Fetch Next From _cursor Into @Cd_Aux,@Cd_TDI,@NDoc,@RSocial,@ApPat,@ApMat,@Nom,@Cd_Pais,@Ubigeo,@Direc,@Telf1,@Telf2,@Correo,@Obs,@Estado,@CA01,@CA02,@CA03,@CA04,@CA05,@CA06,@CA07,@CA08,@CA09,@CA10,@Cta
	While @@Fetch_Status = 0
		Begin
			set @Cd_Vdr=USER123.Cod_Vnd2('''+@RucE+''')
			if(select count(*) from vendedor2 where RucE='''+@RucE+''' and Cd_TDI=@Cd_TDI and NDoc=@NDoc) = 0
			Begin
				insert into Vendedor2(RucE,Cd_Vdr,Cd_TDI,NDoc,RSocial,ApPat,ApMat,Nom,Cd_Pais,Ubigeo,Direc,Telf1,Telf2,Correo,Obs,Estado,CA01,CA02,CA03,CA04,CA05,CA06,CA07,CA08,CA09,CA10)
					values('''+@RucE+''',@Cd_Vdr,@Cd_TDI,@NDoc,@RSocial,@ApPat,@ApMat,@Nom,@Cd_Pais,@Ubigeo,@Direc,@Telf1,@Telf2,@Correo,@Obs,@Estado,@CA01,@CA02,@CA03,@CA04,@CA05,@CA06,@CA07,@CA08,@CA09,@Cd_Aux)
			End
			Else
			Begin
				Update
					Vendedor2
				Set 
					CA10=@Cd_Aux
				Where
					RucE='''+@RucE+'''
					and Cd_TDI=@Cd_TDI
					and NDoc=@NDoc
			End
		Fetch Next From _cursor Into @Cd_Aux,@Cd_TDI,@NDoc,@RSocial,@ApPat,@ApMat,@Nom,@Cd_Pais,@Ubigeo,@Direc,@Telf1,@Telf2,@Correo,@Obs,@Estado,@CA01,@CA02,@CA03,@CA04,@CA05,@CA06,@CA07,@CA08,@CA09,@CA10,@Cta
		End
Close _cursor
Deallocate _cursor
'
Print @Consulta
Exec(@Consulta)
--[user321].[Proc_Transf_Vend] '11111111111'
-- Leyenda
--JJ <11/01/2011>: creacion de procedimiento
GO
