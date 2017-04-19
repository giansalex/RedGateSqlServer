SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [user321].[Proc_Transf_Prv_PA_CBLD]
@RucE nvarchar(11),
@Cd_Aux char(7),
@Cd_Prv nchar(7) output
AS


--Set @Cd_Prv=dbo.Cod_Prv2(@RucE)


declare @VarAux varchar(8000)

set @VarAux='
declare @Cd_TDI	nvarchar(2)
declare @NDoc varchar(15)
declare @RSocial varchar(150)
declare @ApPat varchar(20)
declare @ApMat varchar(20)
declare @Nom varchar(20)
declare @Cd_Pais nvarchar(4)
declare @CodPost varchar(10)
declare @Ubigeo nvarchar(6)
declare @Direc varchar(100)
declare @Telf1 varchar(20)
declare @Telf2 varchar(20)
declare @Fax varchar(20)
declare @Correo varchar(50)
declare @PWeb varchar(100)
declare @Obs varchar(200)
declare @CtaCtb	nvarchar(10)
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
declare @Cd_Prv char(7)

--Insert Into Proveedor2(RucE,Cd_Prv,Cd_TDI,NDoc,RSocial,ApPat,ApMat,Nom,Cd_Pais,CodPost,Ubigeo,Direc,Telf1,Telf2,
--					   Fax,Correo,PWeb,Obs,Estado,CA01,CA02,CA03,CA04,CA05, CA06,CA07,CA08,CA09,CA10)
declare _Cursor cursor for
Select 
	Cd_TDI, NDoc, RSocial, ApPat, ApMat, Nom, Cd_Pais,
	CodPost, Ubigeo, Direc, Telf1, Telf2, Fax, Correo, PWeb, Obs, Estado, 
	CA01, CA02, CA03, CA04, CA05, CA06, CA07, CA08, CA09, Cd_Aux As CA10
from
	OpenRowSet(''SQLOLEDB'', ''netserver'';''Usu123_1'';''user123'',
	''
		select
				Cd_Aux, Cd_TDI, NDoc, RSocial, ApPat, ApMat, Nom,
				case(len(Cd_Pais)) when 0 then ''''9589'''' else Cd_Pais end as Cd_Pais,
				CodPost, Ubigeo, Direc, Telf1, Telf2, Fax, Correo, PWeb, Obs, Estado, 
				CA01, CA02, CA03, CA04, CA05, CA06, CA07, CA08, CA09, CA10
		from 
				Auxiliar 
		Where
				RucE='''''+@RucE+'''''
				and Cd_Aux='''''+@Cd_Aux+'''''
		'' )

open _Cursor
Fetch Next From _Cursor Into @Cd_TDI, @NDoc, @RSocial, @ApPat, @ApMat, @Nom, @Cd_Pais,
	@CodPost, @Ubigeo, @Direc, @Telf1, @Telf2, @Fax, @Correo, @PWeb, @Obs, @Estado, 
	@CA01, @CA02, @CA03, @CA04, @CA05, @CA06, @CA07, @CA08, @CA09, @CA10
	While @@Fetch_status = 0 
            Begin
            if exists (select top 1 *from Proveedor2 where RucE='''+@RucE+''' and Cd_TDI=@Cd_TDI and NDoc=@NDoc)
            Begin
				update proveedor2 set CA10=@CA10 where Cd_TDI=@Cd_TDI and NDoc=@NDoc
				select @Cd_Prv = Cd_Prv from Proveedor2 Where Cd_TDI=@Cd_TDI  and NDoc=@NDoc
            End
            else
            Begin
            Set @Cd_Prv=dbo.Cod_Prv2('''+@RucE+''') 
            Insert Into Proveedor2(RucE,Cd_Prv,Cd_TDI,NDoc,RSocial,ApPat,ApMat,Nom,Cd_Pais,CodPost,Ubigeo,Direc,Telf1,Telf2,
			        Fax,Correo,PWeb,Obs,Estado,CA01,CA02,CA03,CA04,CA05, CA06,CA07,CA08,CA09,CA10)
			Values('''+@RucE+''',@Cd_Prv,@Cd_TDI,@NDoc,@RSocial,@ApPat,@ApMat,@Nom,@Cd_Pais,@CodPost,@Ubigeo,@Direc,@Telf1,@Telf2,
			        @Fax,@Correo,@PWeb,@Obs,@Estado,@CA01,@CA02,@CA03,@CA04,@CA05,@CA06,@CA07,@CA08,@CA09,@CA10)
			Select @Cd_Prv
			End
            Fetch Next From _Cursor Into @Cd_TDI, @NDoc, @RSocial, @ApPat, @ApMat, @Nom, @Cd_Pais,
			@CodPost, @Ubigeo, @Direc, @Telf1, @Telf2, @Fax, @Correo, @PWeb, @Obs, @Estado, 
			@CA01, @CA02, @CA03, @CA04, @CA05, @CA06, @CA07, @CA08, @CA09, @CA10
            End
            -- Cierre del cursor
			close _Cursor

			-- Liberar los recursos
			deallocate _Cursor
'
		
print @VarAux
exec(@VarAux)
--exec SP_ExecuteSql @VarAux,N'@Cd_Prv nchar(7) output', @Cd_Prv out
GO
