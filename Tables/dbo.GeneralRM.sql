CREATE TABLE [dbo].[GeneralRM]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[NroReg] [int] NOT NULL,
[Cd_Tab] [nvarchar] (3) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Area] [nvarchar] (6) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_MR] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Descrip1] [varchar] (50) COLLATE Modern_Spanish_CI_AS NULL,
[Descrip2] [varchar] (50) COLLATE Modern_Spanish_CI_AS NULL,
[Usu] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[FecMov] [datetime] NOT NULL,
[Cd_Est] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[GeneralRM] ADD CONSTRAINT [PK_GeneralRM] PRIMARY KEY CLUSTERED  ([RucE], [NroReg]) ON [PRIMARY]
GO
