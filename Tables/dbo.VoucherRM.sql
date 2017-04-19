CREATE TABLE [dbo].[VoucherRM]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[NroReg] [int] NOT NULL,
[RegCtb] [varchar] (15) COLLATE Modern_Spanish_CI_AS NULL,
[Ejer] [varchar] (4) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_Vou] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[NroCta] [varchar] (12) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_TD] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NULL,
[NroDoc] [nvarchar] (15) COLLATE Modern_Spanish_CI_AS NULL,
[Debe] [decimal] (13, 2) NOT NULL,
[Haber] [decimal] (13, 2) NOT NULL,
[Cd_Mda] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Area] [nvarchar] (6) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_MR] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Usu] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[FecMov] [datetime] NOT NULL,
[Cd_Est] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[NroSre] [varchar] (5) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[VoucherRM] ADD CONSTRAINT [PK_VoucherRM] PRIMARY KEY CLUSTERED  ([RucE], [NroReg]) ON [PRIMARY]
GO
